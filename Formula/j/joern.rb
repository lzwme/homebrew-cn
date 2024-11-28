class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.160.tar.gz"
  sha256 "47a61ab69f637320830b25173fc15e2169f80c7d90421be499e5d7857dc53dd7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ff468f2ac10eac3922cf5d7e41745417f52a33f59423c24f64241b71e490bf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52e17fa9fcef92af5cca7bf6bb051e249fd4587bea473004c46876236bd77ba8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11fdddc1efd64a0ff8398f1ebfae632a064e5a5b533b8dc4df5ce6a905a2ca05"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e5b8377c0896b9d22759122c8fc7cd55cf2bef78c9686fff00381b8be859df4"
    sha256 cellar: :any_skip_relocation, ventura:       "33f457befe9a09b0121713e2fcf7170a0914c0e5df9588e094ef1d0ab8e2ab90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fd967e6e7618b919f6d6bf8d40b0e81028a37bab5ec865b6b5dae53609c79ca"
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