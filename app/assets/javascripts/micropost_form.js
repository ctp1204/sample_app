$('#micropost_picture').bind(<%= t 'shared.micropost.change' %>, function() {
  var size_in_megabytes = this.files[0].size/1024/1024;
  if (size_in_megabytes > Setings.views.shared._micropost.size_megabytes) {
    alert(<%= t 'shared.micropost.maximum_file' %>);
  }
});
