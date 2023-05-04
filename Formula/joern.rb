class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1660.tar.gz"
  sha256 "4d376dbf33f320027543bb9b4939a7dba937cab726c440e984ae156212b9e323"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "775cae6d4d42c199ba17c6ba7f479f30b1ddacbe4ea5fc5a04534f94a3a79fee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8fbcddd4a3cd570e82609f47f4c8c2cc066d2cfbea1082e09738a5ab8e35bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "229b8eb5a74b91fbf380c825a794c3b8cd744f0c6302c6a9fa0e2f1abef71785"
    sha256 cellar: :any_skip_relocation, ventura:        "bea86dc56c1da454a10ae8e3cfb7278ce77cf6a2168e0b99285843fa65dab5a0"
    sha256 cellar: :any_skip_relocation, monterey:       "174d00605d0b7e16683d2728386ff212f59de4dc528663d9273e04878d983dc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d87f073adfc670af189dfcf3016558d6e15a53bdab4427dc06adabc6b3fd7808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171478e71925e06a550cb9c2fa9ce4487a419d337c99c7a0b2cd3e62fbde05b3"
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