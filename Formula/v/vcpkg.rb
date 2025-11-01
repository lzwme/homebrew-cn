class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghfast.top/https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-10-16.tar.gz"
  version "2025.10.16"
  sha256 "70c25e3c3653e917c8d776c90b35b55490152bec36b8be87ca88491697fde3ef"
  license "MIT"
  revision 1
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
    sha256 cellar: :any,                 arm64_tahoe:   "873c34e3f99a7997215192fde00f98988237e2c048d90218bbb45bfe08471c6a"
    sha256 cellar: :any,                 arm64_sequoia: "68406e2d085c69d20c67f7e10f46c6255587b117cb776c0321a7be64e1b27944"
    sha256 cellar: :any,                 arm64_sonoma:  "0adc67aca72dfe2221783f13ae5941876e39a35606c2bc7e0e0d6063a8e2e3b7"
    sha256 cellar: :any,                 sonoma:        "8644221c17f6d1cc616fa4f7be900ab8ba8a78df5c1ec5f05f87d0f12206c8e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e04b09aa086260813feec548f6e2520ff166b5347412f3f832d06930fa13497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b740efebb04f73e6100e84b9c9449d1a7f6e9cb76154fc2778d5855bdca2c46d"
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