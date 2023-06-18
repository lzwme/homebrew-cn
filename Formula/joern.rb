class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.2.20.tar.gz"
  sha256 "77a82e92cad5b07e1dacb1b6ebfc318eacccdd21947e7e2f2106b28c92120bf9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b67a8a8c4253c825d081e6968aafcbea68a439bf940455cbdb8d0c44099d4e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc7b68bd729b3d4054fdc9e0b4aa55aa21ae2c253b9c656c7448c7e12d565c4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8eea9a204c9cb8e95790980d0d1e542cc3b43274132b3f21e62f515f69819f5"
    sha256 cellar: :any_skip_relocation, ventura:        "bfdbc45e475df6a5d2ecacaa428a6b9e095f73824648cc7514cfea796f9a1e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "309f102890a24594c27faf657af51bd64cb607c27e2b947a9fd709af53d66c1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fd83749baf8c095b20623eb97633e3a8eb8c4d398ae4b03e45a006260aa36dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e921fda6f667ca3bfb16b4b0a7ba0aec3759d5efed88e859f7ef8360c057baf"
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