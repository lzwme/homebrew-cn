class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1650.tar.gz"
  sha256 "22a8606129c04f08e65436b751c2db06c85d78b7c1ffaa1b8e7ba85bbd366b9c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0c3d8ccbc13afcd0863a589d921dfa065d1604509a354b5db9007b8ac7d868d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdf60b77f50cb1880451aefc8f06c0c0519952050ae57f55cf49086d6547df3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23cf101b12850710ca70b83eb212601c0e3fec3d37d12bf6577aceb80e96c8c6"
    sha256 cellar: :any_skip_relocation, ventura:        "a6aacfbc9b77acf65ff9a5bef20a0b4ff3b4f11b5629bfccc914187750be47ae"
    sha256 cellar: :any_skip_relocation, monterey:       "40eb79bf817d3bfba177b9dea1deccec707b7bbabe36a4be9831759cc9c22d26"
    sha256 cellar: :any_skip_relocation, big_sur:        "6649f11442dc0b6c1390e7891a76c180b9c71000ae9fc41de26723c2151996ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12be6e8752069d76138821e80dc449269be214f7c7c4f00190ecd858ae313708"
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