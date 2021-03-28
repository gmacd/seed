const Builder = @import("std").build.Builder;
const builtin = @import("builtin");
const CrossTarget = @import("std").zig.CrossTarget;

pub fn build(b: *Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const target = CrossTarget{ .cpu_arch = .i386, .os_tag = .freestanding, .abi = .none };

    const exe = b.addExecutable("seed", "src/main.zig");
    //exe.setTarget(builtin.Arch.i386, builtin.Os.freestanding, builtin.Environ.gnu);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.setLinkerScriptPath("linker.ld");
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
