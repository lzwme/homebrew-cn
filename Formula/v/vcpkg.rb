class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-12-09.tar.gz"
  version "2024.12.09"
  sha256 "4db7060703a7671688dc14a65f6e4b70c73d2ad9f47d5f85782169bc259beae6"
  license "MIT"
  revision 1
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
    sha256 cellar: :any,                 arm64_sequoia: "a22f0cef7b7bb07fdd0aa868c0705a73e87a0903d099c5abddddb00207bec726"
    sha256 cellar: :any,                 arm64_sonoma:  "4ac8d10aff6d508e6482d786baf9fbeddf688b76abdf149d201a4c0922b57b7f"
    sha256 cellar: :any,                 arm64_ventura: "32246cd0145a4ea729c36242cc7415a805df0ae5b5cfeccb61e46dd9ffa5aac2"
    sha256 cellar: :any,                 sonoma:        "bf80b6ec4a678d67a3ea5b90df9ed3a4ba19cbaee364d3a8443767c6e7060111"
    sha256 cellar: :any,                 ventura:       "233418a2f2ce5a7343e74b880c09409eefdbb43c424612a1fdaff9460facdac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766b8be92f475b8fceaf7dfa66691ae7a0a5644ebc6606e14080928279495110"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

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