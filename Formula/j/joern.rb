class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v2.0.150.tar.gz"
  sha256 "c1e7d612886664c77fb30c56e6c5412e35dd4d2032d30f364775d65a00e4e55c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7535041e658d19f718d2abe553f3dd61dcd67e548a2ac5abaad7d9585c145d8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7535041e658d19f718d2abe553f3dd61dcd67e548a2ac5abaad7d9585c145d8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7535041e658d19f718d2abe553f3dd61dcd67e548a2ac5abaad7d9585c145d8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "feab2de5d0d8ecd7deae61472727cd077099cb739948fdce29167f5b047d71be"
    sha256 cellar: :any_skip_relocation, ventura:        "2bf0b9a1b0a2b91b5c106adb9ea5dc034180838cf246c61be7f7d11486b3160e"
    sha256 cellar: :any_skip_relocation, monterey:       "cc43f5cddbbcde809526bd927d7597596949b980e50e9d79146c5d5e5cd70a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44bf249c61497f251422a1c4fdb38ff638a188e28e3564bb368c26e89f6507d3"
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