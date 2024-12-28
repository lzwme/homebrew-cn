class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.compoac-devpoac"
  license "Apache-2.0"
  revision 2
  head "https:github.compoac-devpoac.git", branch: "main"

  stable do
    url "https:github.compoac-devpoacarchiverefstags0.10.1.tar.gz"
    sha256 "ba6a4b2df33ab9bb4eb5923e550bfe81725658fa6a647be5b0b4508ebfe7acc8"

    # Backport build fix for tbb 2022
    patch do
      url "https:github.compoac-devpoaccommit97cc65443b8d0a938a9cfdbfbbbe4b83f73976a8.patch?full_index=1"
      sha256 "f3d5885a17ce00cc7f1568504a128f36704875bd41a66d7dcbfcdc3e7d53c538"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "354ebe892337d536503fc470d83534785290a807a154683e8b2e604f73585198"
    sha256 cellar: :any,                 arm64_sonoma:  "045d528aedc63e629247d2276876a63ca3a062766a79406f21f47b8cf4c1bab6"
    sha256 cellar: :any,                 arm64_ventura: "952a59a87cb6cc4c84f4e8151d653ec9874f03729187f90060cf2deb71fda171"
    sha256 cellar: :any,                 sonoma:        "0ddd945a97c2d8e9e3b477bac5a0cb45678b3f23178ce035151858dae8bee0c8"
    sha256 cellar: :any,                 ventura:       "52f87b42f28b1f2c8ccc626f03e1b320af07d171fa83373e396dfa6267fb98d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a129a4491cd1660b74f8634903cbdae62cf12e861e3ba91364d1643ce61ea0"
  end

  depends_on "nlohmann-json" => :build
  depends_on "toml11" => :build
  depends_on "curl"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "pkgconf"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "gcc" # C++20
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    # Avoid cloning `toml11` at build-time.
    (buildpath"build-outDEPStoml11").install_symlink Formula["toml11"].opt_include
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin"poac", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}poac run").split("\n").last
    end
  end
end