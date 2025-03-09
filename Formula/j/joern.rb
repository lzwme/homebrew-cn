class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https:joern.io"
  url "https:github.comjoerniojoernarchiverefstagsv4.0.280.tar.gz"
  sha256 "b4acf25f4ef89170cd1c44291fa7526492bd332a5bd738f5ea1d686d87684649"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a71dc0014960c5d80480930d7f25a7e1785b51eb7b93afcb9f7692751b88d820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a71dc0014960c5d80480930d7f25a7e1785b51eb7b93afcb9f7692751b88d820"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c3e174853851f4eb9c021baa45cab89a8746bfcb82a02a84372799eb43b7641"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e0c012397c9d905404e5f7f29843b6fe4651438000fb7204471c9e332ca53a"
    sha256 cellar: :any_skip_relocation, ventura:       "7cb4e92095629fdfc87ab0a393db3ca8e5f60a9d81a7f3d332adb599b42d4915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "572401bb814d1d79a431a522f3a5e669e19081841ea00ff50a4f5d4a3f646cb5"
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