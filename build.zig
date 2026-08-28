const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var unibilium = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const lib: *std.Build.Step.Compile = b.addLibrary(.{
        .name = "unibilium",
        .linkage = .static,
        .root_module = unibilium,
    });

    lib.installHeader(b.path("unibilium.h"), "unibilium.h");

    unibilium.addCSourceFiles(.{ .root = b.path("."), .files = &.{
        "unibilium.c",
        "uninames.c",
        "uniutil.c",
    }, .flags = &.{ "-DTERMINFO_DIRS=\"/etc/terminfo:/usr/share/terminfo\"", "-DTERMINFO=\"/usr/share/terminfo\"" } });

    b.installArtifact(lib);
}
