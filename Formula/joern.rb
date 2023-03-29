class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1550.tar.gz"
  sha256 "7aa48b4cd62f0ec15b24f30045e1209dd813ea18ac062b8236303c8a76e59a52"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceb6bacb093477798ee366f77addc0add9283df746e85b843fe9e4a260309d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "801bfd7aaffafe4460a1260e9b80f68525c82fee8141fefd578ae1bdbcf37866"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89714a83fd176495becc6abe5f3827d88ce9749df59261f2272749564f1927f5"
    sha256 cellar: :any_skip_relocation, ventura:        "89db9b4298bd5d8a2f2869a6921978eec0b1f65af9d12e61e2f74655b25169e8"
    sha256 cellar: :any_skip_relocation, monterey:       "c47ed4562915049796798bf7fd6953c2b4b602869d9531eb12b4a5ebcf685dc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e11c080cb8e1580ed79812365022903498ae8987efab85a3103aa6de0f02242a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0494de852ecfb9c2fb35d7410b36bc54932bc8615b0f67b2c818e0d8dc5dc6b1"
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