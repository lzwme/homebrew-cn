class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  # Newer than what livecheck picks up, but we need it for fmt 11.
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-08-01.tar.gz"
  version "2024.08.01"
  sha256 "cb94fa640676e4577ed39fc763178f4661848b5321207c74b3ea411e45f1a95c"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "10592e7ee14a04f6efe9c56247f0bdc8596b68dc6c2e7683d6e8b650db0135ae"
    sha256 cellar: :any,                 arm64_ventura:  "85d40acd871a3b97af5149cef7e823058de2dbd5ad35f56c0f38e2fb14b9b7a0"
    sha256 cellar: :any,                 arm64_monterey: "424d45a8ff27d3c358601762b0a5b0cbf179b8549d3ae08a72522453a0e381c3"
    sha256 cellar: :any,                 sonoma:         "54b860b600668ffbcaa7c6b6d07b65a90838416130bc97666c109356fd945315"
    sha256 cellar: :any,                 ventura:        "77541573ffdd20b86077203e84ec021bc27f694129ee0035f769bdf6705babeb"
    sha256 cellar: :any,                 monterey:       "0e1c7c1f620dd81a4b92ff63d95cfd47303e08c97d44138716b925d7749c26c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21114027d1a6c1b626f819d895be844c351a576c2ba0cc30ae8efea482fd1395"
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