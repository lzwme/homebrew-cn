class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.310.tar.gz"
  sha256 "ba2176afc59b452681c3b2d32db9cd8cccf3a64d9904299b7f0d448fe20ccec6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76113f5629fae70b75ce612cd02bca439269c88cb21f6a6df120fc0b015f9343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76113f5629fae70b75ce612cd02bca439269c88cb21f6a6df120fc0b015f9343"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dcb7e39b45495c7f5f39f172cab8876729aa9016e99ac458a4b1bbd509a4b94"
    sha256 cellar: :any_skip_relocation, sonoma:        "39ee68ba75c8d0892dd52b2d89febf7a72a7e3894696f21ef45ca8a45563e5b4"
    sha256 cellar: :any_skip_relocation, ventura:       "ed6efcf9a184c721af2d4801b7dfd645626b6fc24a1043fc1bde4643e6d7b73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae4a789e752af2ae9c300761bacf6cf6a721a4b57e84d195ddcd5988fb5ce7b0"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  uses_from_macos "zlib"

  def install
    system "sbt", "stage"

    cd "joern-clitargetuniversalstage" do
      rm(Dir["***.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    libexec.glob("frontends{csharp,go,js}src2cpgbinastgen{dotnet,go,}astgen-*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (binf.basename).write_env_script f, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    CPP

    assert_match "Parsing code", shell_output("#{bin}joern-parse test.cpp")
    assert_path_exists testpath"cpg.bin"
  end
end