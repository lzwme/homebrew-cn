class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2025-06-02.tar.gz"
  version "2025.06.02"
  sha256 "eb80f9c56bff1d8349cbdd7804a320d7392a873a4b49c87cf1f378b4cd512c6e"
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
    sha256 cellar: :any,                 arm64_sequoia: "e72e89dc6dc6a7ee947a8b9e54efc00f16bf39e3703da4a877f5ba03d5238cbd"
    sha256 cellar: :any,                 arm64_sonoma:  "89439508fa09654c9c1f2069cc028a288bff566be5ca07da804ef0f9a7a45e8e"
    sha256 cellar: :any,                 arm64_ventura: "3a2923ce1239dff6825ce4cc4927a91c2b18151fd60acfcd7017c77c18dcc420"
    sha256 cellar: :any,                 sonoma:        "c6f8bf88e9c72affac7866601a2756a9259a48285cddd8c6bb6cad1ce8b4c9c3"
    sha256 cellar: :any,                 ventura:       "c3175fd1ed7a05217c743b409eb6c2d1df3ef49ce38452d260556c514af6406b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f48a524bda37a5cbea20b524f42ced7bce7ffb2173114cd90684ef0631ddb269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7c770847ac233d589a397e24537ab7fd3cf1d6d1bdb2cbfbfc66ed554b1f08"
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