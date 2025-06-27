class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.380.tar.gz"
  sha256 "8c4f29b04f3eca831b288fc386da376dc69b14c0760de79ccbcfe9a25b62767b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8049644c6b11f1e6b199fa127d817c8707aba0b9fef86bd78c737331ff6aa71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8049644c6b11f1e6b199fa127d817c8707aba0b9fef86bd78c737331ff6aa71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8049644c6b11f1e6b199fa127d817c8707aba0b9fef86bd78c737331ff6aa71"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df227ff04d141efee03c76389c89ae176fbfe9be25775045c5d4c00f7cff049"
    sha256 cellar: :any_skip_relocation, ventura:       "93787589c5aff716079ff192e5140ec736e58772dada0b924b854bab6c290b59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56113b53fc5b82add585b9a4808fc53595731df491967fb39ed829b5f2e94954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "950ceabad1bf4cec168ec9a072b8f40bdf6672eaac1e35f54f3532f1c2daa33a"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  uses_from_macos "zlib"

  def install
    system "sbt", "stage"

    cd "joern-clitargetuniversalstage" do
      rm(Dir["***.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    libexec.glob("frontends{csharp,go,js}src2cpgbinastgen{dotnet,go,}astgen-*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (binf.basename).write_env_script f, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    CPP

    assert_match "Parsing code", shell_output("#{bin}joern-parse test.cpp")
    assert_path_exists testpath"cpg.bin"
  end
end