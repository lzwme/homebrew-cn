class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-12-09.tar.gz"
  version "2024.12.09"
  sha256 "4db7060703a7671688dc14a65f6e4b70c73d2ad9f47d5f85782169bc259beae6"
  license "MIT"
  revision 2
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
    sha256 cellar: :any,                 arm64_sequoia: "e8bf0373f491e7a508a464cdc352642a1dd7b67cb00dab502b66143c73528faa"
    sha256 cellar: :any,                 arm64_sonoma:  "2c2576494f306a15d4496d8eba15d8264c4173bdbe4b6b458fa59a6ba6173710"
    sha256 cellar: :any,                 arm64_ventura: "e744d39e1e5850f5d1b6921912474d34f39c33c63f69507744dba1d7a643b561"
    sha256 cellar: :any,                 sonoma:        "18ce4b3a27c32f755f98ce9ee04f0b31af2aac70ef8289e76e9e0941656a621f"
    sha256 cellar: :any,                 ventura:       "a4228786f9acbbcbd25a394f815d31fd31b62459701632c586f1122e3926ff14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492ae5101b26512611bd00590feb5134e056113af7e2b540612ad045840537cf"
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