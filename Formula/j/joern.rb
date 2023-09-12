class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://ghproxy.com/https://github.com/joernio/joern/archive/refs/tags/v2.0.80.tar.gz"
  sha256 "3bbec9a83224420b4cbec9da74edaf815fbf4a57d9c6804d5138e2fe6bbeae8a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "691a66f3a6627127aa68dcf968755af48147ef62b6834fc938b8ab67889a80d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13224d63ff7d8b95417b9bc584b1b166828cdbb77a38070c361d3a165d58b9ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25a79016968e413bd34ba3716a9214bb2d0feedb85b46dfd70faaed99127c624"
    sha256 cellar: :any_skip_relocation, ventura:        "102c00c7a1385e497962deff4503dc3e4087b43d01959b91fe4e78c904974812"
    sha256 cellar: :any_skip_relocation, monterey:       "f0481ea5e4bcfe8ce5cb725c533d86ef47c58c4bd4fd9d99361a43f736ac900e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0481ea5e4bcfe8ce5cb725c533d86ef47c58c4bd4fd9d99361a43f736ac900e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc50655d16ca1fb0c99a7c7bfd6301234f9b4e7243bc926b33067f8818f6b72f"
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