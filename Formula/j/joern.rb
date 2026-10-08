class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.650.tar.gz"
  sha256 "0eafbbcd36809c1a1255ec8393cb6707fb0a1f9064700eb317f03be118ad75ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256               arm64_golden_gate: "657a295e2bad270afd5782d63036d7cfbd4799d0c3c7af6b4c371c0dbd40c7e2"
    sha256               arm64_tahoe:       "2169e3dff52a8d9efaa19bbdfd30d01c8909ea2b13774626719a7743855b0282"
    sha256               arm64_sequoia:     "2a2c248ce0e099f6e446779e4fd11db4b7cf028e47c8a83dce2b95cba37c46a1"
    sha256 cellar: :any, arm64_linux:       "9d02bf67b352ac00aedcb8b36c9129fd755b5a24afe3b5b628d3de88b6a52f3e"
    sha256 cellar: :any, x86_64_linux:      "fb1a5d5ef8c0e358ff0a8df63f7f89ef2a47459019bac2028bd9e20e2f7adae8"
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
    system "sbt", "--server", "stage"

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