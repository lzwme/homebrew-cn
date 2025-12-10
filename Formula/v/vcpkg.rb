class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghfast.top/https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-12-05.tar.gz"
  version "2025.12.05"
  sha256 "d2115e9337e040a3374277f2654aa75338234091fbc8dd43040eebf27f554231"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b848a52993714518f68b586b0afb9086df2ca2c8eab08a4a7cff96972cb79ca7"
    sha256 cellar: :any,                 arm64_sequoia: "0f2a8658f2b86bcbe9eca3647e6c5a504c8300093970a3f9500f765975fcc271"
    sha256 cellar: :any,                 arm64_sonoma:  "32faa8ea26de18ba1ba919969530733a06a8f5f0847a76de83f47090726cd64a"
    sha256 cellar: :any,                 sonoma:        "8cc3f3c05a480c38211841bf512ca2fdb18b177e6c9b2a466619fe3043353a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e825d9d9c5c4c0bcfc43cc52a621db8386e2dbf8dee4e9705cfa5c5b2aa3cce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cfcf62a46d6df5a7b8d24bdf24e2c2d9cb06563b88fd9e5b1d17a169e556add"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  # upstream pr ref, https://github.com/microsoft/vcpkg-tool/pull/1826
  patch do
    url "https://github.com/microsoft/vcpkg-tool/commit/7e5f9b42018d19172e87236783bb0c713f176b7a.patch?full_index=1"
    sha256 "2537ff975b66809c14790887090daacadcdd213123d6356a891667048c3b32fe"
  end

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "include/vcpkg/base/message-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    "-DVCPKG_DEPENDENCY_CMAKERC=ON",
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
    output = shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end