class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghfast.top/https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-07-16.tar.gz"
  version "2025.07.16"
  sha256 "ebede6dff6383c7cf75d17b90546025b2a83a0c952bb9e45de8cfda4d136ff15"
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
    sha256 cellar: :any,                 arm64_sequoia: "d4e25312a2dd5842f47dd3b0df9e65cbb5788766223d5a55998b172516d6f20f"
    sha256 cellar: :any,                 arm64_sonoma:  "1b58516c9b20f363281babfbcc43f7c6f359b1b76fc17106a0d99b77aeebb2fc"
    sha256 cellar: :any,                 arm64_ventura: "e2258b7418a77d385a65bb4a5bdaead00e0d2643c22e4704a92cc2b75ba8435e"
    sha256 cellar: :any,                 sonoma:        "49d4b9fef20a35a5710278be8723fabd2ebabbc5f0a67e60cf0ff91464a2e436"
    sha256 cellar: :any,                 ventura:       "7614f4bf0e50682eda5a749644f9160ed923dc8e8f76f486fc96d4815c1f2c0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7207c1b97df905e2da410a47a2e264a4b0a41d7e0cbfd7f6e0798d8757fb7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6857f54c2a032ce92ace4699319c32d29afdb74dcdf2ed960ebf7ff26135793f"
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