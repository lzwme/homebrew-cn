class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.590.tar.gz"
  sha256 "24a0204330e833d1142c4354dba19148ac467bc61f7dbbd93df1de565d055fdb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fe02a18e7e2ac2a4cb60107ada60bc91e43df55d4cccd67362f2e34bd657342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a778a32b3d420029b529abc3c8b4350d3948c77d1624090af069c5d35ae80d01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79ea525d00b7870b12d88fc1d13146fbd7603533d13f2d5bfbed0637d10dfe46"
    sha256 cellar: :any_skip_relocation, sonoma:        "80441cc4ec0238dc06439ce4cc6bc82af6c364b0def79063a5a1961ac73cf265"
    sha256 cellar: :any,                 arm64_linux:   "b95afc6ab0d87de6ddb34f23320e7c7d22772c1df6a621ca1721ab0b1fe89608"
    sha256 cellar: :any,                 x86_64_linux:  "5584e920840be2edda112a0118bdbc3566ce7271bccf4c35ccb86d3429f91779"
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