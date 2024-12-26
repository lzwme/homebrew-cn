class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.190.tar.gz"
  sha256 "1c6dd4ff82a5c1b25ea53ae219c714b8a086f296c77e8ec4491bea549985a562"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce9438cfa23fd0e47b42c66e6418b184d9c808ac3c7aae1add7caab54f721229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45601d8d0270c642cd347c80a99133dafd9232c10ff8891e618f45508919ff83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1021ae1230ec9a7fdf1c72066658a8bc47ca3cc75e3a5efe833064e3d5124019"
    sha256 cellar: :any_skip_relocation, sonoma:        "feedef1451be3bbf30135660e01ecb091c022f87da550f4bfc3f29e36c505974"
    sha256 cellar: :any_skip_relocation, ventura:       "612d2d5c78e3a3286d94c0026d706d6615fa60a624943bbf920f3487baedb066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4155212f9ef2386bd6fa94276ba7c5d21547ba7d1305f8b8f8d67fcb756cf50f"
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
    assert_predicate testpath"cpg.bin", :exist?
  end
end