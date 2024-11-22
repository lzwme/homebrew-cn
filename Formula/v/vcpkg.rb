class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-11-12.tar.gz"
  version "2024.11.12"
  sha256 "046b87f537ab9d8b56918868037afbf59459b702bc7dfe51b66af4895a817cfd"
  license "MIT"
  head "https:github.commicrosoftvcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(v?(\d{4}(?:[._-]\d{2}){2})i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5b56a9d149909990a4c4be9e174da623a6a68d01d2c32053139d9942c615c15f"
    sha256 cellar: :any,                 arm64_sonoma:  "2c6c6c339abd5c5c01df701cceda94541d18dcc333a9cb4d8b20422e520992b5"
    sha256 cellar: :any,                 arm64_ventura: "fe84e172642a3e1b595d4841481e71a19a65b305f29e593859a30cb397088765"
    sha256 cellar: :any,                 sonoma:        "2ba277e255094ba0337de2c43211b27a8a44d787b9935471c9510f389d46b0fb"
    sha256 cellar: :any,                 ventura:       "e667fa488fd8ba3ba11c2430a823c3a21a8a2a82a4b34fdca8bf45463d74e950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a76474af653913a11dfd43e7f7c825641a5663bfb340389accff3b7505d63e"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "includevcpkgbasemessage-data.inc.h",
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
        git clone https:github.commicrosoftvcpkg "$HOMEvcpkg"
        export VCPKG_ROOT="$HOMEvcpkg"
    EOS
  end

  test do
    output = shell_output("#{bin}vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end