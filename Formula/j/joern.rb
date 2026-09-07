class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.620.tar.gz"
  sha256 "397f3825fb5dd286a1f1846e7a1ce350b395724f0d4b9b038a2b30d4bdc24d33"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256               arm64_tahoe:   "9ceb6497f9d36fbaf59219f4fd2d096da408c551a258aa7a63fcf070a087050c"
    sha256               arm64_sequoia: "e50a857185169fa648d7ffb9f103721c9e26aa1b1658d97f6e24980e77e00e93"
    sha256               arm64_sonoma:  "513717d4af99de1190bf863534818ea5a7794842d3c9e8df5c2faf49371447b4"
    sha256 cellar: :any, arm64_linux:   "4d80806408d6c37ccb8d327a4bb1438efc93293ef42fc76e139619f823f20332"
    sha256 cellar: :any, x86_64_linux:  "659cd3f345f723bcb6a00152a3593d047de9687a38d7f8c003ddcd77961d9b72"
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