class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1740.tar.gz"
  sha256 "bb78a7a1c8b99fc49f5bd7396fec6f4434ffabdb2fc23a01c4df114bea5a1f1f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01d8cf08c3f076eacf21fbef8b17183f8e54997b1fe42844f279413547285e25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b8316347fa47e359a3366396c43af5322dded11843df6daf87391fcc927608"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "017c8a83b167c2a20ab24907d4ff6dd2c43efce6bdf5bf60782d8585ee442507"
    sha256 cellar: :any_skip_relocation, ventura:        "6cedb8ea6868f0a94a42e5434837f7cfd4df71423bbe3a5099b507ec5be9f434"
    sha256 cellar: :any_skip_relocation, monterey:       "94571bbc344087cfbb93f76f5e5777051b8cf92e0fc2d67995e666f87eefeff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1f6f1f06526528e32d20efe1cd527428ccb56fdaceb95a9ee594db992adebf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddcc80deba8e4740d207fb8c432240d3f41f7ea0a7f08323ddd0f782fe293060"
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