class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2025-01-24.tar.gz"
  version "2025.01.24"
  sha256 "b90e4299787e643ec7ca110aa83e7c3bcf602d15ff72aaeb1941d771462b7170"
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
    sha256 cellar: :any,                 arm64_sequoia: "4a99e5821a61987c7306d64f594ca0e238e02e22980bbd79dace903a6f1d62ec"
    sha256 cellar: :any,                 arm64_sonoma:  "af6777f5cad53499c0e7f8ba55cbd1b465d0f9b821db6864c37befd54bfa6f46"
    sha256 cellar: :any,                 arm64_ventura: "2db6866c8af13635db7e71e5d27bb7734fd3df3212b634c3e9c589df20786938"
    sha256 cellar: :any,                 sonoma:        "2684dea1de947e3384b5be7576580e6624b48931e19667bbe4578ebe5c5dab27"
    sha256 cellar: :any,                 ventura:       "b24c091ef30d264302c3a517ac2619a9743ebc455b6705c364c7bcc0b1316527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8ca10d9bc895bbc4e6a56e7a11daf9182e422db7ee819367c15ca4ae13ba9dd"
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