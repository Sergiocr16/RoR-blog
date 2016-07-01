# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ajax:success","form#comments-form" , (ev,data)->
    # $("#comments-box").append("
    # <div class='comment' ,style='border:white 0.2px solid;'>
    #       by
    #       <strong>#{comment.user.email}</strong>
    #       <br>
    #       <span style='font-size:12px;'>
    #           <%=time_ago_in_words(comment.created_at)%>
    #           ago
    #       </span>
    #       <br>
    #       <p>
    #         #{comment.body}
    #       </p>
    #   </div>")
    $(this).find("textarea").val("")
$(document).on "ajax:error","form#comments-form" , (ev,data)->
   console.log data
