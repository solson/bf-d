import std.stdio;
import std.array;

void execute(string source, int tapeSize)
{
    ulong[ulong] loopStarts;
    ulong[ulong] loopEnds;

    // Match loops [ and ] and store their locations
    ulong[] loopStack;

    foreach (i, c; source) {
        switch (c) {
        case '[':
            loopStack ~= i;
            break;

        case ']':
            if (loopStack.empty) {
                throw new Exception("Unmatched ] in program");
            }

            ulong start = loopStack.back();
            loopStack.popBack();
            loopEnds[start] = i;
            loopStarts[i] = start;
            break;

        default:
            break;
        }
    }

    if (!loopStack.empty) {
        throw new Exception("Unmatched [ in program");
    }

    // Set up the virtual machine
    char[] data;
    data.length = tapeSize;
    data[] = 0;

    ulong dp, ip;

    while (ip < source.length) {
        char c = source[ip];

        switch (c) {
        case '+': ++data[dp]; break;
        case '-': --data[dp]; break;

        case '>': dp = (dp + 1) % tapeSize; break;
        case '<': dp = (dp - 1 + tapeSize) % tapeSize; break;

        case '.': write(data[dp]); break;
        case ',': readf("%s", &data[dp]); break;

        case '[':
            if (data[dp] == 0) {
                ip = loopEnds[ip];
            }
            break;
        case ']': ip = loopStarts[ip] - 1; break;

        default:
            break;
        }

        ++ip;
    }
}

void main(string[] args)
{
    execute(args[1], 128);
}
