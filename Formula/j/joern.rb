class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.180.tar.gz"
  sha256 "0229fee7b68ec3e92c2b7c9b5fcafc9d61559b53b1887a71d33d6c567cc88fd3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5babcf007fb9987aa3374ba17739348327d8e940bf41a79cfdaeffa977d91635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15e8b941c2c8afba2579c8e690df17353875bc188910e9fadecccd8df5371d14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e536020de4b7252541c4594211bb58debdf02d76632db5989250398d84e7eee6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5e4933e0b109496c01c3b448f47daaf6617ad205211d8a27717db849a1bed6"
    sha256 cellar: :any_skip_relocation, ventura:       "40127016024067780c98e703f0def18190c003759d60c98271066b46cccc1584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f662c78fc4fded36e389a2be9dbe08d2ec062454e2cdf7560d92c9e2a91cff93"
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