class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1560.tar.gz"
  sha256 "ab0cb7cbea53722a1c6c71c84fa613d68eed35290a0c326d3074bb2a5e520dda"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f874012793117d5f92771cfd13022c5b897b1abdae5596ae61d51b411e54a7ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bc8acc2d1b03521b81fa788cc8d16bdc20d2b2c173dd211e85b28852ef9e252"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d304dd0b63dc427ea4ff455ae7410155aa13a4777a059bbe156203cde13619d1"
    sha256 cellar: :any_skip_relocation, ventura:        "b8bde7a15cb80d7a5569cb695c648983542be5b97b579e602f6c1795a21f9a49"
    sha256 cellar: :any_skip_relocation, monterey:       "e6c64cadbcac43d7da54bc2d0eee3840077376a537c1b6e4be2431e0022e8711"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7333e6107023869f2f128d1744665ecacbc0ef83eec53a2d15329829dc266b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f291388bcb3407d259186450ae8871b776e5ab84df0d35cceffe4cc4778736e5"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk@17"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm_f Dir["**/*.bat"]
      libexec.install Pathname.pwd.children
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env("17")
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    EOS

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_predicate testpath/"cpg.bin", :exist?
  end
end