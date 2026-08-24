class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://ghfast.top/https://github.com/nektro/zigmod/archive/refs/tags/r104.tar.gz"
  sha256 "ae9d845a67750d5f7fae685768cc3bc9bf6de059b767502ffdd8064c5d8e4c96"
  license "MIT"

  livecheck do
    url :stable
    regex(/^r(\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcd9e783eced6eacc76d53a49ea43a88f9f8b3147136feb66656ef42656ef386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e551eaac508c1b8117a8a0bae78976a979e0091fc27146c9944f34568d274a07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b6a145a55809eb0d695ab531e84e6afeae0f29888bf74a06c21455e8c8278fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68a2ac7c8b55cc61a780862cd195c2dffc5fbd30fe8271e46cbd2c093eaa848f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf0aaf77776019d7e004d974ffa476dea039e6b7233ff2149ed1e70e476247cf"
  end

  depends_on "zig"

  def install
    args = %W[
      -Dtag=r#{version}
      -Dstrip=true
    ]

    # Upstream doesn't use `-Doptimize`, see: https://github.com/nektro/zigmod/pull/109
    system "zig", "build", *args, *std_zig_args.map { |s| s.sub "-Doptimize=", "-Dmode=" }
  end

  test do
    (testpath/"dependency/src").mkpath
    (testpath/"dependency/zigmod.yml").write <<~YAML
      id: 8w9skd2bi3x7vh6z6xcu3taaz1tww2ghbjt5p1e9fyj1pgsu
      name: zigmod-test-dependency
      main: src/lib.zig
      license: MIT
      description: Test zig.mod dependency
      min_zig_version: 0.11.0
      dependencies:
    YAML
    (testpath/"dependency/src/lib.zig").write <<~ZIG
      pub fn message() []const u8 {
        return "Hello from zigmod dependency!";
      }
    ZIG
    system "git", "-C", testpath/"dependency", "init"
    system "git", "-C", testpath/"dependency", "add", "."
    system "git", "-C", testpath/"dependency", "-c", "user.name=Homebrew",
                  "-c", "user.email=brew@test-bot.local", "commit", "-m", "init"

    (testpath/"zigmod.yml").write <<~YAML
      id: 89ujp8gq842x6mzok8feypwze138n2d96zpugw44hcq7406r
      name: zigmod
      main: src/lib.zig
      license: MIT
      description: Test zig.mod
      min_zig_version: 0.11.0
      dependencies:
        - src: git #{testpath}/dependency
    YAML

    (testpath/"src/lib.zig").write <<~ZIG
      const std = @import("std");
      pub fn main() !void {
        std.log.info("Hello, world!");
      }
    ZIG

    system bin/"zigmod", "fetch"
    assert_path_exists testpath/"deps.zig"
    assert_path_exists testpath/"zigmod.lock"

    assert_match version.to_s, shell_output("#{bin}/zigmod version")
  end
end