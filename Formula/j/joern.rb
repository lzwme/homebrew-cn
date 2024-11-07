class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.130.tar.gz"
  sha256 "f91c8a8c6f51513794af7b250856dd402b02d42e39c05c30d532e7592ecd94f7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e1fc4c0cb073d49b4faa4e4074a16c3fcb9ad10abfb69505b0fac3d943b88b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e1fc4c0cb073d49b4faa4e4074a16c3fcb9ad10abfb69505b0fac3d943b88b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e1fc4c0cb073d49b4faa4e4074a16c3fcb9ad10abfb69505b0fac3d943b88b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "869f08822bcdff9c4706a9b0d07d6ecec7bc229acd55c307ccabec3e7c4406fc"
    sha256 cellar: :any_skip_relocation, ventura:       "869f08822bcdff9c4706a9b0d07d6ecec7bc229acd55c307ccabec3e7c4406fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546d5f9fdcf66d582e6e6059bcbb47c52b1063ee0923fbfdd514990ae594bf0d"
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