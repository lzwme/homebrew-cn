class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.230.tar.gz"
  sha256 "62c28ecc79ea664da7cd3e854727e2e97fc2bc958b2a62b3580cf29a1f9a6ca4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6fcaad6ace90252bc84f2999fb05f7cd5b811b1d973e781abd201971ab3e4bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceb99db32ca3c5602f5e43777d522ce8c9a953563ab19735d287d5964ae7ce95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "617e3d70fc441854376465f64e1cf56264167d7ab401e5d094e3558ce6264718"
    sha256 cellar: :any_skip_relocation, sonoma:        "91378646396464daf952dcebfdf2b98a03b2d934f93988dcf600fd961e069e28"
    sha256 cellar: :any_skip_relocation, ventura:       "08e06ef83713078be4a813f78f40b9f596ccc653af7ff832759083a76b525c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ff6b6fc66271d4bcd4ecb433e8a99dd93e8b4ce44b2d8b5dcd316c71bc44c3"
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