package models;

import libs.*;

public class Hashtag extends ActiveRecord {
    private String tag;
    private int message_id;


    public int getMessage_id() {
        return message_id;
    }
    public void setMessage_id(int message_id) {
        this.message_id = message_id;
    }

    public String getTag() {
        return tag;
    }
    public void setTag(String tag) {
        this.tag = tag;
    }
}
