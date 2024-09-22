class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-09-18.tar.gz"
  version "2024.09.18"
  sha256 "8e4cf8a6ff5ba392bdbbd0adbe01fbe50dd1515c87a9be22e198a43b36621688"
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
    sha256 cellar: :any,                 arm64_sequoia: "793df037aebbd784c10d75f36ad5d3a613a9fde12eaf23eccf03302bccb4ba34"
    sha256 cellar: :any,                 arm64_sonoma:  "c3191187631c3ae0a71bb56fd019587889920a95cd6f732ecd90198d698f96e4"
    sha256 cellar: :any,                 arm64_ventura: "ffe21ba6c57a90895b1cfe8099183f78fcb01e07eadd38fa3fbbdcd49d52452d"
    sha256 cellar: :any,                 sonoma:        "329c6f47304149abb6b9c22b920910cc7e0208d1f5abf5f3c7d06e73f66a344e"
    sha256 cellar: :any,                 ventura:       "9af04ed835a02a4a4d230b2157cd10abbe81b82444b1719617b7fcf23d962c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c740e42abebf07dee7de269b621cb4b16179746e07d0db38b13af1de95e63ef"
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