import 'package:polymer/polymer.dart';
import 'dart:convert' show JSON;
import 'dart:html';
import '../../lib/paths.dart';

@CustomTag('custom-item')
class Item extends PolymerElement {
  @observable Map object = toObservable({});
  @observable bool pagination = false;
  @observable bool inlineEdit = false;
  @observable String apperance = "view";
    
  Item.created() : super.created();
  
  void view(){
    window.location.assign("$itemViewUrl?id=${object['id']}");
  }
  
  void edit(){
    window.location.assign("$itemEditUrl?id=${object['id']}");
  }
  
  void next(){
      window.location.assign("$itemViewUrl?id=${object['id'] + 1}");
  }
  
  void prev(){
      window.location.assign("$itemViewUrl?id=${object['id'] - 1}");
  }
  
  void save(){
    print("implement save");
    // Setup the request
    var request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
        // data saved OK.
        print(" Data saved successfully");
        // update the UI
        
        //querySelector("#content").appendText(jsonString);
        if(inlineEdit){
          this.object = toObservable({'text':'${request.responseText}'});
          this.apperance = "index";
          
        }else{
          this.object = toObservable({'text':'${request.responseText}'});
                    this.apperance = "index";
                    
          //window.location.assign(itemsUrl);
        }
      }
    });
    request.open("POST", "http://127.0.0.1:8090/$itemSaveUrl");
    request.send(JSON.encode(object));
  }
  
  void delete(){
    print("Delete object with id ${object['id']}");
    // Setup the request
    var request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
        // item deleted OK.
        print("Item deleted successfully");
        // update the UI
        var jsonString = request.responseText;
        
        if(this.inlineEdit){
          this.remove();
          querySelector("#content").appendText(jsonString);
        }else{
          this.remove();
          querySelector("#content").appendText(jsonString);
        }
        
      }
    });
    request.open("POST", "http://127.0.0.1:8090/$itemDeleteUrl");
    request.send(JSON.encode(object));
  }
}