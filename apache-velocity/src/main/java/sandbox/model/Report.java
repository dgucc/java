package sandbox.model;

import java.util.List;

public class Report {
    private EnumStatus status;
    private List<Member> members;
    
    public Report(){}

    public EnumStatus getStatus() {
        return status;
    }

    public void setStatus(EnumStatus enrolmentStatus) {
        this.status = enrolmentStatus;
    }

    public List<Member> getMembers() {
        return this.members;
    }

    public void setMembers(List<Member> members) {
        this.members = members;
    }

}

