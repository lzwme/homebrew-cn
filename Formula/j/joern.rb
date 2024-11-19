class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.150.tar.gz"
  sha256 "47a9bb00933807efcc985ecea33a710702c79189049b14f048d403111f2bf0a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8930684fea1e273fea888d7f9aa8eb6f9a79942c5b35a61656add8f7e30b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6873d48609b2c94f5a0adc8fcd28ceb30d2875b6a43363cb092f016d5fe63b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6873d48609b2c94f5a0adc8fcd28ceb30d2875b6a43363cb092f016d5fe63b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "31bfaeb08f645427eaaf8036acd2842f011367fac07439d6e886e6c533db1cf0"
    sha256 cellar: :any_skip_relocation, ventura:       "cd2c06f252527898471c26362547018d27828e7e50fd0a45339ab78e524646d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e61e299108f4001354534308a6f1034eefa2877edae3e9b3bba987525616742e"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-clitargetuniversalstage" do
      rm(Dir["***.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? "astgen-#{os}" : "astgen-#{os}-#{Hardware::CPU.arch}"
    libexec.glob("frontends{csharp,go}src2cpgbinastgen{dotnet,go}astgen-*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(astgen_suffix)
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
    assert_predicate testpath"cpg.bin", :exist?
  end
end