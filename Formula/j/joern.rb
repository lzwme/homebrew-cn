class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v2.0.160.tar.gz"
  sha256 "13bc431bcc4df7664f4ff2d1a31cb3d274f6eb5659e52d8208c3511181acf934"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faa7629457dc8224bc1702b5105c77796b6f5d783e1708c359cfaac0acae7bab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6c78b7c944f8c58696a1c1c288b30d9ae153e35a26626378d4d8060d9f07072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7660c405f8d042413f3b448a308227aaa3fbb7514e8d95cecd594c1437db778b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c331e39ff97ca7ddfd805c0b2ca9304ba3033ddc8a324bff69a1a18bdb081090"
    sha256 cellar: :any_skip_relocation, ventura:        "eabc81ebc5aee8187c6efe23f7dd00d27bd233fd62c5f60c6147d2bdd673b091"
    sha256 cellar: :any_skip_relocation, monterey:       "d38b1ff56828ee5defe7ac0639c0c7a02ba7b1cce8d7f4dd45e8d76a406ceff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cdcc2416708eae11e4413ddef2f8f731cb160692e48bbaa1e2b63f50dd11a60"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm_f Dir["**/*.bat"]
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    arch = Hardware::CPU.arch.to_s
    goastgen_name = Hardware::CPU.intel? ? "goastgen-#{os}" : "goastgen-#{os}-#{arch}"
    (libexec/"frontends/gosrc2cpg/bin/goastgen").glob("goastgen-*").each do |f|
      rm f if f.basename.to_s != goastgen_name
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env
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