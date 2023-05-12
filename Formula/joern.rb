class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v1.1.1710.tar.gz"
  sha256 "02b038f5c103b7b127907d3c04765e4f9c0db1832d3f4ff9820fc006b868ea55"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c280d1d7fd18f0289a2b94c9f6e9d7872541b1572da848eacc03cd740d481013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62227d0ceac9393db3b94f3e58b8e08516f41e447ee80f5944c9457b846e53e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5453071234ba50d565efd41a44837b2b76618bc9c5fe050b8e9038556c0f284f"
    sha256 cellar: :any_skip_relocation, ventura:        "6d9847e16d2867cbcc364506fe40b2c5c2eaecf093910f26588b0b370d64ddbb"
    sha256 cellar: :any_skip_relocation, monterey:       "ffa4a61784271730acfc45eb9b02f06df9254b7e7b57912e5a860d0d120bed93"
    sha256 cellar: :any_skip_relocation, big_sur:        "9364cdd703185fa57b686ae560b694ca1aae2d3c235b4bab5d7833f7b6eeb7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4bbec5e41277644579215f756e2749ba61879bf7342a8e9c1ac3baa936bbc17"
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