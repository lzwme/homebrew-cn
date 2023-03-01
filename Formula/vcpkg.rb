class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghproxy.com/https://github.com/microsoft/vcpkg-tool/archive/2023-02-16.tar.gz"
  version "2023.02.16"
  sha256 "7e687b1a6e341413d1fa6ee459215f2e1718219b31c9d314ba135e3bc4c861aa"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d{4}(?:[._-]\d{2}){2})["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6de79a189dbe0faff9fcd198cb9ea2869d99fed4db53a19705420a6dd7fdb9d9"
    sha256 cellar: :any,                 arm64_monterey: "40317799c7266efbd00ebed45d4b1a15a8b7f45f619ed1de494b1f1c4dad87b2"
    sha256 cellar: :any,                 arm64_big_sur:  "17a34a9c65ca682d542cd9b0efb3387ca27d990cd0ecee9da610ffecca3d83ea"
    sha256 cellar: :any,                 ventura:        "19a35441b3d955e107fc0ea72b21be8e2c8751846a5a15a077692a7aa6c79ee1"
    sha256 cellar: :any,                 monterey:       "68aec222c699c8d6d5cac3470062cf25ae88dc1233d8ae21294c022240010d8b"
    sha256 cellar: :any,                 big_sur:        "b3d22bf71206263d1fe360b846e3fd19867a46bba1d64ea132a4d6d6fd77e971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95978e25cb17f87806cabad85c56359dd9716ac830c88bda485cfde482cc1c16"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace ["include/vcpkg/base/messages.h", "locales/messages.json"],
              "If you are trying to use a copy of vcpkg that you've built, y", "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root. You must define the VCPKG_ROOT environment variable"
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end