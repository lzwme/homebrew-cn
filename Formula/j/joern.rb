class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.470.tar.gz"
  sha256 "5975d4808948cf790d4dc729bd5e3f26022ba5511caff557f77029c3cd4452a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "043dd3e7d141d4f7a06d9127ceea82497fd24b10649166985aa5c07b0d1a4199"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69d386c625cf8893207994670166920c23013200441fdb35774b0aa46d3a2d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4ba6aa15b2722ba09ce33b1188d26fc0f309bd07746de0879d33415578a7390"
    sha256 cellar: :any_skip_relocation, sonoma:        "be9bc4e4a623f8cf316433ed358ffdc38c45cfaea1e0362a5663f6acc1cbcf4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e23ca19b2f54d8ff728435284fa47f25a8f506f2150f5a836b285b33def78640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ec2703a220878d2f611605fb30d27e0108da3491e93bd28e8163c98ab86f53"
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