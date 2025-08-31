class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://ghfast.top/https://github.com/joernio/joern/archive/refs/tags/v4.0.410.tar.gz"
  sha256 "abee4c6a5f7663074a53b918b9fe57aaada1b8dbfeca603a12abe3f3a29cd243"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1dc0163a00b0a0f9a4aa2d703ea799eae01fab0315a5fcbc84b3b69e92ecc4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b74b6e07cd3f212149b3fd1633138bea802362127d700b170c64104fe152dc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66081be8880a0c9a123a50551ad3c37b5931c87b9c2d6ea7427804ef2c85c6fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ffa968e7ded678d58cf54fe6840f377bf0c5ef845af432fcbbac5b69d8179d3"
    sha256 cellar: :any_skip_relocation, ventura:       "a5d0564a6620e01c25a65c96694b1c828965a0dc66ef6f640d3e733c6316b11d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f28e6f08de1ab70d03874684a93f4c37a729073715c9e9149c1d51d9c33494b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce4b17448fd8d03db17e21d8de76b37b7f37faef12c09bb9732dbfbd986f82e"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  uses_from_macos "zlib"

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