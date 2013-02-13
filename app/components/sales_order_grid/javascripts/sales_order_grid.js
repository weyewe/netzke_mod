{
  initComponent: function(){
		this.callParent();
    this.addEvents('salesorderdelete');
		console.log("after initComponent, addEvents");
    
    // Process selectionchange event to enable/disable actions
    this.getSelectionModel().on('selectionchange', function(selModel){
      if (this.actions.confirm) this.actions.confirm.setDisabled(!selModel.hasSelection());
    }, this);
	},

  onConfirm: function(){
		// alert("Confirm button is clicked");
	    // this.netzkeLoadComponent("add_window", {callback: function(w){
	    //   w.show();
	    //   w.on('close', function(){
	    //     if (w.closeRes === "ok") {
	    //       this.store.load();
	    //     }
	    //   }, this);
	    // }, scope: this});
			var selModel = this.getSelectionModel();
			var recordId = selModel.selected.first().getId();
			this.canBeConfirmed({record_id: recordId}, function(data){
				this.getStore().load(); 
			}, this); 
  },

	showError : function( data ) {
		Ext.MessageBox.alert('Confirmation Status', data['message'] , null);
		if( data['success'] === true ){
		} 
	},
	
	refreshChildData : function(){
		console.log("inside the refresh child data");
		this.fireEvent("salesorderdelete");
		// var fireEventResult = this.fireEvent("salesorderdelete", this, {}); 
	}
	
}
