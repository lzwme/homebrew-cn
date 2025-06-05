class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.370.tar.gz"
  sha256 "26655cb5243414a563b65df89b7296423943490595792ade264a82c30e76f5ec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff018940e4454e365f659f080089e55a981a5919f3f24322363866f8f083ca87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff018940e4454e365f659f080089e55a981a5919f3f24322363866f8f083ca87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff018940e4454e365f659f080089e55a981a5919f3f24322363866f8f083ca87"
    sha256 cellar: :any_skip_relocation, sonoma:        "8530e24f243e90b62dda97fc82d23a752a3650fdf032431e18ae9f96a467b47d"
    sha256 cellar: :any_skip_relocation, ventura:       "5b00d473ac9299385b41bce7686fdd9766bcd6a24a666834e01c0385daa96fa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a27bc60be497d1d51585b5f1e0715e4dd7783601c8e0b0913b7c6cf8f8d8f4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38b4cb3c57899a4e30250bc6fd4ff933553d350041444758ff4a59ae0ecfca8"
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