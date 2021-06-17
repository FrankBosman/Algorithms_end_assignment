class MainBranch extends SideBranch{
    ArrayList<SideBranch> sideBranches = new ArrayList<SideBranch>();
    PVector position;

    MainBranch(PVector position, int segmentAmount, float startAngle, ArrayList<SideBranch> sideBranches){
        super(startAngle, segmentAmount);
        this.sideBranches = sideBranches;
        this.position = position;
    }

    void display(int[] locationBranches){//, ArrayList<SideBranch> sideBranches){
        int currentBranch = 0;
        // wind();
        pushMatrix();
        rotate(startAngle);
        translate(position.x, position.y);        
        for(int i = 0; i < segments.size(); i++){
            if(locationBranches[currentBranch] == i){
                pushMatrix();
                    sideBranches.get(currentBranch).display();
                popMatrix();
                if(currentBranch < locationBranches.length-1) currentBranch++;
            }
            segments.get(i).display();
        } 
        popMatrix();
    }
}