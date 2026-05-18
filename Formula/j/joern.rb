class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.540.tar.gz"
  sha256 "6cc71fed2c11e66df3e2874c9341d208f3f87816942549377c15672b46522235"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3e0c23bbc0b14b10774f9bf6c5f22912c949e3ed65d1758ab13f906a2f17f76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca705df5494be86acac5e62fbd06ed2271a5817e02fc8cfc7db52db5479b0a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "410629145c94613d69b8f72739e6c598292d5295e30406a5e0ebb35fe60038f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f68a287e3475666948f48c96f07fb5074881473731bb83fd2da13a534be8393f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f659dd24ad91e275db183033d4969c7075ecaad4386dddb9874eac4c8377a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e34d74700bd2414566457da0aa41155fedfd1a63c11eefd24a904c688c58af"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
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
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env
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