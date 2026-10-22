class Zigmod < Formula
  desc "Package manager for the Zig programming language"
  homepage "https://nektro.github.io/zigmod/"
  url "https://ghfast.top/https://github.com/nektro/zigmod/archive/refs/tags/r106.tar.gz"
  version "r106"
  sha256 "faea9f58a0cf9f582d51ebd7252b624e062c1bb6e41ea98bddbe4592005999ae"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^(r\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48f1354039c373af7484e8c01d708e8a4a4b9cef3a79d6638e4e3388b9be8799"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8f569311a51a5a7aa1c9a5e8724f8343588750593fe9acef4f5f5681ab9393c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15f5993924de3b66fa1d7730c850b500ac35ed8e4307df16b7ed32028a9d8f76"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "029e185a8e67b79bf24d1450efbc0b5d27bf9971546b6584bfd9105369291c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d04a4f7e7db74ba760cf6bef4866b38b5c024a0643fe6f40b0387a7a5d7b2994"
  end

  depends_on "git" => :build # `zig build fetch` runs `git clone --revision` (git 2.49+)
  depends_on "zig"

  deny_network_access!

  def fetch
    system "zig", "build", "fetch", "-Dtag=#{version}"
  end

  def install
    args = %W[
      -Dtag=#{version}
      -Dstrip=true
    ]

    system "zig", "build", *args, *std_zig_args
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
      min_zigmod_version: #{version}
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