class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.200.tar.gz"
  sha256 "e1cef414b0bc1ae650fb91d841705d350ba72b95e61356e29ed492817c4cd1e8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e781d41e3e51ae1e046d23de31ea7b355350dab0d4a906b5b57e37863ebee586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d183f43f8328f66d2fc77b33d83c45c0af47149025187d21c55fadc51d4bb73f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67c795792554324a120a2b45ee3964bab5f9af7e749d6d09f9e27857a59e7bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc8c39ec765539905b6615de651c9fa6d8c88925ff339d3bad019d62f36745cd"
    sha256 cellar: :any_skip_relocation, ventura:       "76f357b8e61205837090935e145d138d1f6c54e786e1ca72397da7580c4b7245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c4d359c8aaee20ef1fd055b1dbbd75905d67b46b4d0c0bc9b9398d533d1919"
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
    assert_predicate testpath"cpg.bin", :exist?
  end
end