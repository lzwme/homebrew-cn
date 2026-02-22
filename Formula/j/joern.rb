class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.480.tar.gz"
  sha256 "8cd66165eaf611d338ffd018e9df067aa6fff93f52e57185e1db8ac711adb6d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6de7b8205d579804b299fe7f3fea51329f79344e674aab378bb965f1c9a110dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b436ca2d69423771d102f66dda3fac8852420c6d7ca543aedafac0a673b935a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b495f3c4eee250063b364f3b0ba2116be46a963242c6af1c0da81d2eaf1f56"
    sha256 cellar: :any_skip_relocation, sonoma:        "d07bd2a5e58022d9bb64a09db572acc59f622c70ed71b7d8d5b88e47b93c423b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52353842426b865232095cc92830dedf0461599b7d4711bb4e1be0618d1311e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8667203af136a789c23991e8ab577c7705cc7da094722ac2be1c54bfc8e4e058"
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
    libexec.glob("frontends/{csharp,go,js}src2cpg/bin/astgen/{dotnet,go,}astgen-*").each do |f|
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