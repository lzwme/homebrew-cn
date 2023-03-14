class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1514.tar.gz"
  sha256 "3c738ad52d02eeb43c4920498b8c363e1cbd6b86f87115a6766b49dcc30090af"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38ee0635a36eefcb0e4b570f13482c26597bd6e339b5008a0ea917f3ea7821b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2814f8d89037b473c307862edb37c45c9d97b93cb419a9d963017ade78ee0e74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4af05a89f820de7342b70401672ff977e2ae11f398552ba13bd80436d00bfd19"
    sha256 cellar: :any_skip_relocation, ventura:        "c12271b758982856debe9b8477bf5ed8395055d6cf4a3d455639ce46434b910e"
    sha256 cellar: :any_skip_relocation, monterey:       "13ff0a6cc7c8cf7a53eaf39ab6aec5b8502376ba4d5bfa45416c6b44c168ee85"
    sha256 cellar: :any_skip_relocation, big_sur:        "d139dfa6468b354362ef37de7042dbd68f7afa31b3af2a49cb248bcfd413559c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e4347d261be7864c2ff5b11adcbef5e8fd3a6d5d281a22090f36886f707c0c"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  def install
    system "sbt", "stage"

    libexec.install "joern-cli/target/universal/stage/.installation_root"
    libexec.install Dir["joern-cli/target/universal/stage/*"]
    bin.write_exec_script Dir[libexec/"*"].select { |f| File.executable? f }
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV.append_path "PATH", Formula["openjdk"].opt_bin

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