class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v2.0.170.tar.gz"
  sha256 "0cb68e7bf7420faf2a38feafd7f01375104d5f7e20697a6ee895387897503bfb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c18cb7ce32d0e92b31c21c5879ac3181c5d4bc569d81103254698177144e7eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c18cb7ce32d0e92b31c21c5879ac3181c5d4bc569d81103254698177144e7eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c18cb7ce32d0e92b31c21c5879ac3181c5d4bc569d81103254698177144e7eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "315b79ea08c712950522aa6d3be427b659af4cc9c6cfd240c60de327d5a16613"
    sha256 cellar: :any_skip_relocation, ventura:        "4907b996e5197834fed580974c8baeeffe37d0c561c5476ae4cd33df34050eeb"
    sha256 cellar: :any_skip_relocation, monterey:       "49de2fd4fd783bbe90655728f6fab8b484ce9ece509b915df28f4121987cca02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2cbb14fdc1a28d350c2b2187a385737cf882b56746a8f5bd8f4f9fa16826bba"
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