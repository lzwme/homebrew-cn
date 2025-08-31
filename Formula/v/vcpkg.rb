class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghfast.top/https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-08-29.tar.gz"
  version "2025.08.29"
  sha256 "017df4120fbd237d66381418631ec041ecec1f31dde50163878bd40ab41ee1b9"
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
    sha256 cellar: :any,                 arm64_sequoia: "f2cc8f3e6eca6cf31513294ca5b50492425f660d13dbc917d74932f30c930b8f"
    sha256 cellar: :any,                 arm64_sonoma:  "4bc22babba7b2e004cedf6ea763dd5371fb69d3708ca753afb7b9999826ade33"
    sha256 cellar: :any,                 arm64_ventura: "bcff27a3ececb3575e5f5ae8fb80b599dba2a558350495bd9017a1ef16047114"
    sha256 cellar: :any,                 sonoma:        "02a23346171574b76b7a55cdd80ae1e9b71733bd67c2d3e09cdb71f7feb9bb74"
    sha256 cellar: :any,                 ventura:       "6649a4e2434dd60fe93ebf5b439fb0e3edfc0e6459633bc09b8307a269158545"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d737455fbd4aaf1f048d5124da4cc162b4bad21c3e2af60fd5e77d702b403de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5edb3302a0c36da6d64c0792c4c63e02312284f551c89cbd0796ffa90f9da1fd"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

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