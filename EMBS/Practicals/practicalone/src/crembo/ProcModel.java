package crembo;

import ptolemy.actor.TypedAtomicActor;
import ptolemy.actor.TypedIOPort;
import ptolemy.actor.util.Time;
import ptolemy.data.DoubleToken;
import ptolemy.data.IntToken;
import ptolemy.data.RecordToken;
import ptolemy.data.Token;
import ptolemy.data.type.BaseType;
import ptolemy.kernel.CompositeEntity;
import ptolemy.kernel.util.IllegalActionException;
import ptolemy.kernel.util.NameDuplicationException;

/**
 * Created by pi514 on 16/10/2015.
 */
public class ProcModel extends TypedAtomicActor {
    protected TypedIOPort input;
    protected TypedIOPort output;
    protected TypedIOPort discard;
    protected TypedIOPort util;

    private Time nextIdleTime;
    private boolean busy;

    public ProcModel(CompositeEntity container, String name) throws IllegalActionException, NameDuplicationException {
        super(container, name);

        input = new TypedIOPort(this, "input", true, false);
        output = new TypedIOPort(this, "output", false, true);
        discard = new TypedIOPort(this, "discard", false, true);
        util = new TypedIOPort(this, "util", false, true);
        util.setTypeEquals(BaseType.DOUBLE);
    }

    @Override
    public void initialize() throws IllegalActionException {
        super.initialize();
        nextIdleTime = getDirector().getModelStartTime();
    }

    @Override
    public void fire() throws IllegalActionException {
        super.fire();
        RecordToken t = (RecordToken) input.get(0);
        IntToken comptime = (IntToken) t.get("comptime");

        Time currentTime = this.getDirector().getModelTime();
        if (nextIdleTime.subtract(currentTime).getLongValue() <= 0) {
            nextIdleTime = currentTime.add(comptime.doubleValue());
            output.send(0, t);
            busy = false;
        } else {
            busy = true;
            discard.send(0, t);
        }

        DoubleToken token = new DoubleToken(busy ? 100.0d : 0.0d);
        util.send(0, token);
    }
}
