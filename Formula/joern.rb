class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1522.tar.gz"
  sha256 "bd8d2281ad4c990ce48e7f742aaae102f175a00c01138677d876be4cbd63b4fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61ab3eb93bc9d52dcae81c62baf10c9e0af5ed7e1e5cd86d75290cca7f102900"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e57e048b82c120bb6c33b822a777485b91e36c63aa77037cd1f1c2446d971c32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b29e0108351d7b78c61029e302914263f6d7ac4303bb6ce85b37101e20b19c09"
    sha256 cellar: :any_skip_relocation, ventura:        "743202f05847916496dd29c7f9627cea82f35354e4b5b67b87799b6d26f72f62"
    sha256 cellar: :any_skip_relocation, monterey:       "4efc081061754b6622022f137ddd131a5c827d2eaf7b7af6eea358d956e14f29"
    sha256 cellar: :any_skip_relocation, big_sur:        "b36961ee0c2be52837b8dd46a56c1d41b925e7d5f4d97939e91981d9a16d6610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff9f7aef5b357a82ae2ef8f3a4621a2be8bd8733d9da3f43e8a77854f23ba5f"
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