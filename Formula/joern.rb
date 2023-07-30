class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v2.0.30.tar.gz"
  sha256 "b080db011709a55db406990269ff23a39c92a1dff88ea21fc9d528f63f4bffbb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b9c25b8b83251977ac8008304f91583e0c4ac34f0697f7a91e30dbf844959f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a39e07f8f7709614139a364386c7e5b308de3b48958828c99e6178427e51cd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "319b7f98bf3f3cf3c60d14a5a5bbbcaa960ccde768ed69dcf28ef7eb2c2fd8d9"
    sha256 cellar: :any_skip_relocation, ventura:        "64928a10f04ac9c717db07d07953fbdbc7f9044834f000fe6a5be0d27d3faa7c"
    sha256 cellar: :any_skip_relocation, monterey:       "8e9866c3da57f233f2f388f2cf0f011c2cfbe8eb6b413db9e9479711646ea022"
    sha256 cellar: :any_skip_relocation, big_sur:        "623593523afc5789314e16be533138a93e0d1e16c23185f03adcde29086db4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3f08a15887edadf489d6eeaba84d4b95299f4122282e76ffe9846d3cbe393af"
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