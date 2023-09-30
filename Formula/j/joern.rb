class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v2.0.100.tar.gz"
  sha256 "0961415d883064beba7ed79d4701738734d225f663f03606ef15eb0ed2c735ca"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46ebe75f022466adbd8ad14d3f9cc4e239573c44bf9263bd26cbd25be4e10e47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46ebe75f022466adbd8ad14d3f9cc4e239573c44bf9263bd26cbd25be4e10e47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca1772b70fbd94beae6e2fa364b6919c20771eb4164b3444f50d8a9e35a0acfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "051f89df5d5d1e5cba7a255cbb78c04346b1ecf8f89df4f967d073657109e604"
    sha256 cellar: :any_skip_relocation, ventura:        "1105149e621e09e54520d452602bf4023be05fc25cde16ba01c8685145be133e"
    sha256 cellar: :any_skip_relocation, monterey:       "91be9daa5e71f1eed965d915b5513535eafd282b8604d5d6151c43469b984e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00d66a62524382c0b1d372ddccbaa04ddeab60254202bdd2d910a8de353408b5"
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

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    arch = Hardware::CPU.arch.to_s
    goastgen_name = Hardware::CPU.intel? ? "goastgen-#{os}" : "goastgen-#{os}-#{arch}"
    (libexec/"frontends/gosrc2cpg/bin/goastgen").glob("goastgen-*").each do |f|
      rm f if f.basename.to_s != goastgen_name
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