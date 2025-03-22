class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.300.tar.gz"
  sha256 "575ae3f9c949586bd65605fdde303d5b1ba27cbef61e98c7f98d1b1f0ac01b04"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67ebb55286aa074e7a0489fce8bd0d714ddf615939f4ea959b457b9d3ba69185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1912cb85d59e42dd7265b15802197f894d3a67e2c378d34928fc3587c0a31d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ede91d1625b3a4914aec4d00af1c08dd95e863a390efb3bbc9b19a7a3ae2827d"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ef6dfe5d6bd3189e8c2554a60fbf6abfe8ff27443951342239b717bc89c771"
    sha256 cellar: :any_skip_relocation, ventura:       "ecf6a0c09fadc4acfef9432cefcfbeede3af3872652bc1ea9bf0ea05a6cc3f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab353c0ade6825add17fcb3e1b7dcf7d0346d26deb6a28bb94c416f3cf1ca4c"
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