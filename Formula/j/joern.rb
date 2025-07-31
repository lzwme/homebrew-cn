class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.400.tar.gz"
  sha256 "52042fb486f624a0b123c4d126fbaedef266fb85bc4262a0ca65e2652d9cb5ab"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd4423ca5aa46f83979340bbc3d1ef75ee4a9bef7d1fc8c3ffcbcb777e7e7ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac2a1bece78fa060944de569cd39dc3528ca1bb5fc1930ae880f5edf471e17b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80c447d6198d43de577cc3b472178513ece08fd98c372cf23da4056e3506b899"
    sha256 cellar: :any_skip_relocation, sonoma:        "80a1e4b8068e8f88336fd616a36af90989f8e1f2c41be429440665fe13769155"
    sha256 cellar: :any_skip_relocation, ventura:       "65bbe0e46f715a3a7af2a79f7c3f202b11ff72335eb67a5003b20e52225ebc65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ea6e2bfcd37ed8009a4a6e00a7d3a74d1c5bf1ea7beeb8a179121ba048d2a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "608c250aa3d0cc57a7629cd3040a6019e59e84d54f00eb227d13e4497be85a84"
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