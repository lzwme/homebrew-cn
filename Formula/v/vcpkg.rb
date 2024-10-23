class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-10-18.tar.gz"
  version "2024.10.18"
  sha256 "70c176265e518e87ec78946370fd4c388cc6996af868323b9c117c6fcca34452"
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
    sha256 cellar: :any,                 arm64_sequoia: "0e1de1af717c5f613cdcb1fbffc6cecb65bef0a036caedd53638434e270efedf"
    sha256 cellar: :any,                 arm64_sonoma:  "9f0c59cf2203dee17a9a8829caa70047fa8c8dc27d9c9f1a6e98ca48c19318c6"
    sha256 cellar: :any,                 arm64_ventura: "70e357c7afa52e629ecfadc7a0269b342f28be12599a34e7f36b9d7849adb40d"
    sha256 cellar: :any,                 sonoma:        "163963ead376f19f42a39c0aa6e16e55036865e6fe2d9d5c40e2ccee63ab99ec"
    sha256 cellar: :any,                 ventura:       "55d56a3fa8832e630e1049c0b11e8e6f06fa5c9833d49f2aacdc6af3746e107d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a109bafd040b142113a536c7f2c57a4fa630f08e1f6147a2be52620fe3f4453"
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