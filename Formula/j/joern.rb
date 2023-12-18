class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  # joern should only be updated every 10 releases on multiples of 10
  url "https:github.comjoerniojoernarchiverefstagsv2.0.180.tar.gz"
  sha256 "62116442be2cecd3a8200daf2a76f0d12981e597715b7e3d3d020087e645da86"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9011dc63ff8f4658d4927dbacf6126d42ee27b1810d4a3bbf209340faa8ef96f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ecdb9627348d9ea005b0cfef373468821d1e2fccf203d72ede87a08bcb2a905"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9011dc63ff8f4658d4927dbacf6126d42ee27b1810d4a3bbf209340faa8ef96f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2335a87379c3a5002a30de175aef789006d890a4c7a349a1de5efd09ca8bde6b"
    sha256 cellar: :any_skip_relocation, ventura:        "aca3f6ca4c62cd5b7ed18380e4bec62eba924259dd1dbdf0de15ce710733a5d0"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c398e07f1e533957c483a9763d1ac990b45cfbd59b81d3517056a7acdd8aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32bf5a0667fb2f1f9f94dcb928be2854612fab65911e9af3ac5a48bb25d459c"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-clitargetuniversalstage" do
      rm_f Dir["***.bat"]
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    arch = Hardware::CPU.arch.to_s
    goastgen_name = Hardware::CPU.intel? ? "goastgen-#{os}" : "goastgen-#{os}-#{arch}"
    (libexec"frontendsgosrc2cpgbingoastgen").glob("goastgen-*").each do |f|
      rm f if f.basename.to_s != goastgen_name
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (binf.basename).write_env_script f, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    EOS

    assert_match "Parsing code", shell_output("#{bin}joern-parse test.cpp")
    assert_predicate testpath"cpg.bin", :exist?
  end
end