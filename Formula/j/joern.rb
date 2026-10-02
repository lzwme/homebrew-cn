class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.640.tar.gz"
  sha256 "8996100d3225b50b2fbcfee971176b05d5ba40df8003d05efaa1b5da6a624d5f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256               arm64_golden_gate: "b577a5693529960002df8294cfbb8043d77bced3e54244af5b928e2d2ce1b4e0"
    sha256               arm64_tahoe:       "24fb25eed5c1d26571aa5c41eae70c754ca86b45a7f2bf0966021fc60d313e8e"
    sha256               arm64_sequoia:     "58a819b89459ecd19fd14a641d9b27dcab377a253efda91bc93b51ce12b649d9"
    sha256 cellar: :any, arm64_linux:       "8c50b634e9a58c2d9a1926c2d0fab05f565b5a116edd79e9f27d7c075af8d390"
    sha256 cellar: :any, x86_64_linux:      "4e4cb2423f650d5cbf20382a3f7f5427cf9bd75625a4494d77f026f383a58a25"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk@25"
  depends_on "php"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm(Dir["**/*.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    astgen_suffix << "-mac" if OS.mac?
    libexec.glob("frontends/*/bin/astgen/*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    # Special case for `SwiftAstGen`
    deuniversalize_machos libexec/"frontends/swiftsrc2cpg/bin/astgen/SwiftAstGen-mac" if OS.mac?

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env("25")
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    CPP

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_path_exists testpath/"cpg.bin"
  end
end