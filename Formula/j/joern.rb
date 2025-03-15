class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.290.tar.gz"
  sha256 "d11ac73c0eddc4098fc90584fcbf2428a112a19b2083626fd08a9e9101d1841a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9f0d608bea015bd182b74f5873ddf2df53932fd4a76969a71a835040abfdfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a9f0d608bea015bd182b74f5873ddf2df53932fd4a76969a71a835040abfdfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a9f0d608bea015bd182b74f5873ddf2df53932fd4a76969a71a835040abfdfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aae29619cad681ebb2dd8c113866076d80cdfc140043a1941dcdbad9a918f3e"
    sha256 cellar: :any_skip_relocation, ventura:       "f69f32a29c10d09c6f36801b6817eb6c60c6f02142a9fa51bb4161a65d4bfa95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bd7a906830ee2042ea41abb2d947f8478a77a496776068597c9c3dc01713fa4"
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