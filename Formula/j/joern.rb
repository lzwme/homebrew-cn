class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.490.tar.gz"
  sha256 "43cc39f976c5f9712fc63742ea9b2367ac35f10da335ea365fca795840a049f2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "013473c49168751e6618c0628046178b098f7b7969ad009a0705f236466e63c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6a9ada454b2112b715f4b58abfe40c14d69d679001afb7cbc590eeaecac48ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013473c49168751e6618c0628046178b098f7b7969ad009a0705f236466e63c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e47f4c97a38aeed6e5248938bc2ddb5bcc76cb77e24a5553fa3719f9a0cc76c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0356fe09d4884e75fbc9e6a5176566db578856b4212f0a81f2b21d60417b870f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14b05566cdd534138c2f290ba41cc70956bbd5773427c830b12e45f4ddd5555f"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm(Dir["**/*.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    libexec.glob("frontends/{csharp,go,js}src2cpg/bin/astgen/{dotnet,go,}astgen-*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    CPP

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_path_exists testpath/"cpg.bin"
  end
end