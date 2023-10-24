class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v2.0.130.tar.gz"
  sha256 "df79165a9eaf2fe8a488d3a05d608a738d631f78fa88915cd5e8d59a73a11fef"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6706800fc72f5d7b3ea1017af99bf1876033fbef39a0ec9f413cdc8f1bc5aeed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6706800fc72f5d7b3ea1017af99bf1876033fbef39a0ec9f413cdc8f1bc5aeed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6706800fc72f5d7b3ea1017af99bf1876033fbef39a0ec9f413cdc8f1bc5aeed"
    sha256 cellar: :any_skip_relocation, sonoma:         "660a74429c09298c2d8ce40a39d8ee15d2a6df60e363ae628a7bcb69d5ff2e5f"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3d2edb85a4db150e36a0c838998694e5fbaa4e057b0009bfb169869fe20192"
    sha256 cellar: :any_skip_relocation, monterey:       "30c80f9c74477cbf840466fcd2951b0b7f5522e5cdfef512b2373fb8f73159e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ec6750481784d178e829fe94894492257c8a83a0a466d8a2e054ffcfe16b46"
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