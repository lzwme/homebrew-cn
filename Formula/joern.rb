class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1720.tar.gz"
  sha256 "c87c3fe9543c1f2097eea0eed4aac6632cacb4e0d10a9754aed3a43d30266f33"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3606b7fe777386ab8445a670262f1fca1f7e886c832dc0a6395e41ce99f9db14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "840b4a91b88a42bfcea34a0471f5a41f16e3dfb1753319cf3bbec96edbc5fdee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "579c3b97697e5a3ad1fd633e36fc419cd5d3b065dd9100777bac434aea3f8c4f"
    sha256 cellar: :any_skip_relocation, ventura:        "cd5266a56f519b6275879bcfb5da6e2fa1ce037705c4e0e2b7b8e62efa74cd00"
    sha256 cellar: :any_skip_relocation, monterey:       "f291b987f1cd8ba447c6ffeb6a1e7a89de884ad831d6fdc8e2c28a113cd3e96c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0d055c2a2f932371e0506df77ebad1bb4f177e02862b8acea10109d3a9918c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df5b9a016b8640a49348061067d7d2cd66344419eab3bce69e8046eac5cd8dc9"
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