class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1680.tar.gz"
  sha256 "aeda0126b9896c9bbdef73116cb4cc8854533e07ce0d7d5b90d1c9c1aff30534"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b97fe7448d492c82c6aa046f1b20ea76bc91126d9dcbcb799937668b67f608d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f8ac4409aa39949f8776ed66cd970927ef1752f62dedc517cd256ef43222a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c9bc2b2f8c9ff0afc3758cff96b8e7f65f9be32c058760e191d3cb378e97b2"
    sha256 cellar: :any_skip_relocation, ventura:        "7f6d22496af513d7bbc448e91e50b886f9eb6e97b026c4e278cea189dc63f55a"
    sha256 cellar: :any_skip_relocation, monterey:       "5952c72f86c6414c9f28cdc3daa28df92ab6ea627bf5c03d0d509296d792e0ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "96bc81ca6b2c23c6439836b39034970c225e119efd9b0c31e943297aca3cadd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70cb863734a24fd72c32474da95002de68a1f8c5a2b6ed355cd51f66476145d0"
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