class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghproxy.com/https://github.com/microsoft/vcpkg-tool/archive/2023-03-01.tar.gz"
  version "2023.03.01"
  sha256 "9f99f0d88ac495338606b50d940ab013a0a5e22f094c3805a579b5308e67880a"
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
    sha256 cellar: :any,                 arm64_ventura:  "f937b7062c4793ca577b41213e60bb9e3d0d2006d07817ff89e872f7d624086d"
    sha256 cellar: :any,                 arm64_monterey: "a2be690564e325c93ea1c7d883e8e20a1ff4b3ae150d91f4d4c41beea3f08b70"
    sha256 cellar: :any,                 arm64_big_sur:  "c54dc514492e43717985528db192c4b651a3929830a5d3421d8529e0c79d189f"
    sha256 cellar: :any,                 ventura:        "75a413650ae2f0c20433835d78500a28a9aff4c9fe89929959d27ed575bba303"
    sha256 cellar: :any,                 monterey:       "27e0d30b821ae3d48d37ded2682893bf6be75e0acb34387766e86b7c22d19b5f"
    sha256 cellar: :any,                 big_sur:        "ab0107cdf62d1d5e8adb79862e6c935719b8fe2a53b988dba174fb471b50f6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec1f5d070c4022a8abdf20808586cc8d56b9721c826cd017407e5da83776bf0a"
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