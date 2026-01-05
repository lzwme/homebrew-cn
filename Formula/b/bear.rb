class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://ghfast.top/https://github.com/rizsotto/Bear/archive/refs/tags/4.0.0.tar.gz"
  sha256 "27dbb0b23c4d94018c764c429f7d6222b2736ffa7b9e101f746bc827c3bf83a0"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd0e223eca36212cf0d2f241c7125685ec295e974f97a34558da9f0f5a09f60f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b65b4be2ddbc983c6e6816b77e7af8319018245fb408789385b037c53e520e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b592bb458ac7b0b268c3ab6d99940505218db1dddbab96016540f9ce6ddd78"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e568dbf70c67422189c162c0639179b700bdb407a59aa4ff5ae64ffb9eb6e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c64aecd479c7c0aeb67e02142ffc3838651a436439487fd5f77534300b9b0f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1cb90c53b09900e7fd97c7f287e39bc0d199a7a867238ac96013ae79951b2c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :test
  end

  def install
    # Patch build.rs to use Homebrew's libexec path instead of /usr/local/libexec
    inreplace "bear/build.rs",
      'WRAPPER_EXECUTABLE_PATH=/usr/local/libexec/bear/wrapper");',
      "WRAPPER_EXECUTABLE_PATH=#{libexec}/bear/wrapper\");"

    inreplace "bear/build.rs",
      'PRELOAD_LIBRARY_PATH=/usr/local/libexec/bear/$LIB/libexec.so");',
      "PRELOAD_LIBRARY_PATH=#{libexec}/bear/lib/libexec.so\");"

    mkdir_p libexec/"bear"

    system "cargo", "install", *std_cargo_args(path: "intercept-wrapper", root: libexec)
    mv "#{libexec}/bin/wrapper", "#{libexec}/bear/wrapper"

    system "cargo", "install", *std_cargo_args(path: "bear")

    if OS.linux?
      system "cargo", "build", "--release", "--lib", "--manifest-path=intercept-preload/Cargo.toml"

      mkdir_p libexec/"bear/lib"
      cp "target/release/libexec.so", "#{libexec}/bear/lib/"
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