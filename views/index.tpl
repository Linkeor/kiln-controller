<!DOCTYPE html>
<html lang="en">
<head>

 <title>Kiln Controller</title>
 <meta name="viewport" content="width=device-width, initial-scale=1.0">

 <script src="/static/assets/js/jquery-1.10.2.min.js"></script>
 <script src="/static/assets/js/jquery.event.drag-2.2.js"></script>
 <script src="/static/assets/js/jquery.flot.js"></script>
 <script src="/static/assets/js/jquery.flot.resize.js"></script>
 <script src="/static/assets/js/jquery.flot.draggable.js"></script>
 <script src="/static/assets/js/bootstrap.min.js"></script>
 <script src="/static/assets/js/jquery.bootstrap-growl.min.js"></script>
 <script src="/static/assets/js/select2.min.js"></script>
 <script src="/static/assets/js/picoreflow.js"></script>

 <link rel="stylesheet" href="/static/assets/css/bootstrap.min.css"/>
 <link rel="stylesheet" href="/static/assets/css/bootstrap-theme.min.css"/>
 <link rel="stylesheet" href="/static/assets/css/bootstrap-modal.css"/>
 <link rel="stylesheet" href="/static/assets/css/select2.css"/>
 <link rel="stylesheet" href="/static/assets/css/picoreflow.css"/>

</head>
<body>

 <div class="container">
  <div id="status">
   <div class="ds-title-panel">
    <div class="ds-title">{{ translate("Sensor Temp") }}</div>
    <div class="ds-title">{{ translate("Target Temp") }}</div>
    <div class="ds-title">{{ translate("Heat Rate") }}</div>
    <div class="ds-title">{{ translate("Cost") }}</div>
    <div class="ds-title ds-state pull-right" style="border-left: 1px solid #ccc;">{{ translate("Status") }}</div>
   </div>
   <div class="clearfix"></div>
   <div class="ds-panel">
    <div class="display ds-num"><span id="act_temp">25</span><span class="ds-unit" id="act_temp_scale" >&deg;C</span></div>
    <div class="display ds-num ds-target"><span id="target_temp">---</span><span class="ds-unit" id="target_temp_scale">&deg;C</span></div>
    <div class="display ds-num ds-heat-rate"><span id="heat_rate">---</span><span class="ds-unit" id="heat_rate_temp_scale">&deg;C</span></div>
    <div class="display ds-num ds-cost"><span id="cost">0.00</span><span class="ds-unit" id="cost"></span></div>
    <div class="display ds-num ds-text" id="state"></div>
    <div class="display pull-right ds-state" style="padding-right:0"><span class="ds-led" id="heat">&#92;</span><span class="ds-led" id="cool">&#108;</span><span class="ds-led" id="air">&#91;</span><span class="ds-led" id="hazard">&#73;</span><span class="ds-led" id="door">&#9832;</span></div>
   </div>
   <div class="clearfix"></div>
   <div>
    <div class="progress progress-striped active">
     <div id="progressBar" class="progress-bar"  role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
      <span class="sr-only"></span>
     </div>
    </div>
   </div>
  </div>
  <div class="panel panel-default">
   <div class="panel-heading">
    <div id="profile_selector" class="pull-left">
     <select id="e2" class="select2" style="margin-top: 4px"></select>
     <button id="btn_edit" type="button" class="btn btn-default" onclick="enterEditMode()"><span class="glyphicon glyphicon-edit"></span></button>
     <button id="btn_new" type="button" class="btn btn-default" onclick="enterNewMode(selected_profile)"><span class="glyphicon glyphicon-plus"></span></button>
    </div>
   <div id="btn_controls" class="pull-right" style="margin-top: 3px">
    <div id="nav_start" class="btn-group" style="display:none">
     <button type="button" class="btn btn-default" style="visibility: hidden;"  onclick="runTaskSimulation();">{{ translate("Simulate") }}</button>
     <button type="button" class="btn btn-success" data-toggle="modal" data-target="#jobSummaryModal"><span class="glyphicon glyphicon-play"></span> {{ translate("Start") }}</button>
    </div>
    <button id="nav_stop" type="button" class="btn btn-danger" onclick="abortTask()" style="display:none" ><span class="glyphicon glyphicon-stop"></span> {{ translate("Stop") }}</button>
   </div>
    <div id="edit" style="display:none;">
     <div class="input-group">
      <span class="input-group-addon">{{ translate("Schedule Name") }}</span>
      <input id="form_profile_name" type="text" class="form-control" />
      <span class="input-group-btn">
        <button class="btn btn-success" type="button" onclick="saveProfile();">{{ translate("Save") }}</button>
        <button id="btn_exit" type="button" class="btn btn-default" onclick="leaveEditMode()"><span class="glyphicon glyphicon-remove"></span></button>
      </span>
     </div>
     <div class="btn-group btn-group-sm" style="margin-top: 10px">
      <button id="btn_newPoint" type="button" class="btn btn-default" onclick="newPoint()"><span class="glyphicon glyphicon-plus"></span></button>
      <button id="btn_delPoint" type="button" class="btn btn-default" onclick="delPoint()"><span class="glyphicon glyphicon-minus"></span></button>
     </div>
     <div class="btn-group btn-group-sm" style="margin-top: 10px">
      <button id="btn_table" type="button" class="btn btn-default" onclick="toggleTable()"><span class="glyphicon glyphicon-list"></span></button>
      <button id="btn_live" type="button" class="btn btn-default" onclick="toggleLive()"><span class="glyphicon glyphicon-eye-open"></span></button>
     </div>
     <div class="btn-group btn-group-sm" style="margin-top: 10px">
      <button id="btn_delProfile" type="button" class="btn btn-danger" data-toggle="modal" data-target="#delProfileModal"><span class="glyphicon glyphicon-trash"></span></button>
     </div>
    </div>
   </div>
   <div class="panel-body">
    <div id="graph_container" class="graph"></div>
   </div>
   <div id="profile_table" class="panel-footer" style="display:none;"></div>
  </div>
 </div>

 <div id="jobSummaryModal" class="modal fade" tabindex="-1" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
   <div class="modal-content">
    <div class="modal-header">
     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
     <h3 class="modal-title" id="jobSummaryModalLabel">Task Overview</h3>
    </div>
    <div class="modal-body">
     <table class="table table-bordered">
      <tr><td>{{ translate("Selected Profile") }}</td><td><b><span id="sel_prof"></span></b></td></tr>
      <tr><td>{{ translate("Estimated Runtime") }}</td><td><b><span id="sel_prof_eta"></span></b></td></tr>
      <tr><td>{{ translate("Estimated Power consumption") }}</td><td><b><span id="sel_prof_cost"></span></b></td></tr>
     </table>
    </div>
    <div class="modal-footer">
     <div class="btn-group" style="width: 100%">
      <button type="button" class="btn btn-danger" style="width: 50%" data-dismiss="modal">{{ translate("No, take me back") }}</button>
      <button type="button" class="btn btn-success" style="width: 50%" data-dismiss="modal" onclick="runTask()">{{ translate("Yes, start the Run") }}</button>
     </div>
    </div>
   </div>
  </div>
 </div>

 <div id="delProfileModal" class="modal fade" tabindex="-1" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
   <div class="modal-content">
    <div class="modal-header">
     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
     <h3 class="modal-title" id="delProfileModalLabel">{{ translate("Delete this profile?") }}</h3>
    </div>
    <div class="modal-body">
     {{ translate("Do your really want to delete this profile?") }}
    </div>
    <div class="modal-footer">
     <div class="btn-group" style="width: 100%">
      <button type="button" class="btn btn-danger" style="width: 50%" data-dismiss="modal">{{ translate("No, take me back") }}</button>
      <button type="button" class="btn btn-success" style="width: 50%" data-dismiss="modal" onclick="deleteProfile()">{{ translate("Yes, delete the profile") }}</button>
     </div>
    </div>
   </div>
  </div>
 </div>

 <div id="overwriteProfileModal" class="modal fade" tabindex="-1" aria-hidden="true" style="display: none;">
  <div class="modal-dialog">
   <div class="modal-content">
    <div class="modal-header">
     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
     <h3 class="modal-title" id="overwriteProfileModalLabel">{{ translate("Overwrite this profile?") }}</h3>
    </div>
    <div class="modal-body">
     {{ translate("Do your really want to overwrite this profile?") }}
    </div>
    <div class="modal-footer">
     <div class="btn-group" style="width: 100%">
      <button type="button" class="btn btn-danger" style="width: 50%" data-dismiss="modal">{{ translate("No, take me back") }}</button>
      <button type="button" class="btn btn-success" style="width: 50%" data-dismiss="modal" onclick="deleteProfile()">{{ translate("Yes, delete the profile") }}</button>
     </div>
    </div>
   </div>
  </div>
 </div>

</body>
</html>
