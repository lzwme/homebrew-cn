class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/4.2.0.tar.gz"
  sha256 "711fc941bb124f802236c6e7e87f60118b005d0b9efaeb601cbd5b178c5d2fd3"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b771bf7e7167c01ab000a931ef7df381d86b00277af13dfc9002c71159bd85a4"
    sha256 cellar: :any, arm64_sequoia: "b0d3e8ab8dd6a83d197c8d8488b1bfad05dd7acebf61413cd085cf6d68f8d6c8"
    sha256 cellar: :any, arm64_sonoma:  "3951d672b3318295aa3658c7d46bb0cc73bd098d15d172cb4899dac58828c025"
    sha256 cellar: :any, sonoma:        "612cca68de259c9d52be38429b3f510fba7c9af06481b7f3203b568a6e8543b2"
    sha256 cellar: :any, arm64_linux:   "51101e4c69702b0fa22117bed1709153c9150bd506d31a67a0298b61c7d9496b"
    sha256 cellar: :any, x86_64_linux:  "b3c0943933895d34c50811790d24c560797e10843405283199e481da6da853a3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  def install
    %w[driver wrapper].each do |crate|
      # Install binaries to `target/release` because `scripts/install.sh` expects them here
      system "cargo", "install", *std_cargo_args(root: "target/release", path: "crates/bear-#{crate}")
    end
    ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld" if OS.linux?
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release"

    with_env(PREFIX: prefix) do
      system "scripts/install.sh"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end