class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v2.0.90.tar.gz"
  sha256 "abf053caf4749acf3b23a35a844b2a29307fcb982564924cb0c8702ac169537f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5ed4e037d45cbc8a6806ca672d94c4bfc5ea5a1ef8739afb8c20a8e3f17b23a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2eb69c2bc0f410cf2d4662cc7f0f579c57c435e6646fb748b01e8869a853a55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cb52c6e78ae636013aaf220e874378aa272fa5b3516f2ab6e682d11cd6931e8"
    sha256 cellar: :any_skip_relocation, ventura:        "569b394437b02c7280200e0eccfb62a0bb85bca5ea9eb0b5ce1052f79254098f"
    sha256 cellar: :any_skip_relocation, monterey:       "6523f9e141a1d4116683d10306465051fa26c3650e171e1f5f2c8411ab0f2483"
    sha256 cellar: :any_skip_relocation, big_sur:        "91f8240a53d06552c80783eaf1455443399dcb0cfcce6969db4a2c00e95b20dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b8694f2439b2f123ccb41f0c91f9626fafbd4f5f3250450abfcbdbfd7f4e34d"
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