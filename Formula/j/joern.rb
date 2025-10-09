class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.430.tar.gz"
  sha256 "e39b51b306dee6d3cb069ceb76e2ca2f4e2c280be6d1cad9762b049d70047a67"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4677dda6b549c26451c44afe3ab2259174a9174afb747554e689f87fa12035b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "083fa0e784e2787ab5f14553624863607060c57b809b64d32c9d39952966b104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06b8d6a7a052d1ad90dc641cd82f4e9aa590fe2ac6497190f164e20eadaa59a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f4d7be1c1d18a7bce7480ef9b7843b9be356de647e8d2c4ea077cc0b409f1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03e7073f61faaf78e8c71e40eba77829d86c90cdb254fd371a716e916187ef93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac8352fa0b0d8c1c1ea6f1456265077350be00f298922e7bc470b69b75850a36"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  uses_from_macos "zlib"

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