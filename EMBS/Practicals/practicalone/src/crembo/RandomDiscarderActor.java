package crembo;

import ptolemy.actor.TypedAtomicActor;
import ptolemy.actor.TypedIOPort;
import ptolemy.data.IntToken;
import ptolemy.data.Token;
import ptolemy.data.expr.Parameter;
import ptolemy.kernel.CompositeEntity;
import ptolemy.kernel.util.IllegalActionException;
import ptolemy.kernel.util.NameDuplicationException;

import java.util.Random;

/**
 * Created by pi514 on 16/10/2015.
 */
public class RandomDiscarderActor extends TypedAtomicActor {

    private Random r = new Random();

    protected TypedIOPort input;

    protected TypedIOPort output;
    protected Parameter discardage;

    public RandomDiscarderActor(CompositeEntity container, String name) throws IllegalActionException, NameDuplicationException {
        super(container, name);

        input = new TypedIOPort(this, "input", true, false);

        output = new TypedIOPort(this, "output", false, true);

        discardage = new Parameter(this, "percent to discard");
        discardage.setExpression("20"); // initial value
    }

    @Override
    public void fire() throws IllegalActionException {
        super.fire();
        Token t = input.get(0);

        if (r.nextInt(100) > Integer.parseInt(discardage.getValueAsString()))
            output.send(0, t);
    }
}
