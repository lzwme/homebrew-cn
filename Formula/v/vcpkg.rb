class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-12-09.tar.gz"
  version "2024.12.09"
  sha256 "4db7060703a7671688dc14a65f6e4b70c73d2ad9f47d5f85782169bc259beae6"
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
    sha256 cellar: :any,                 arm64_sequoia: "245045992529bced711fec15e359ec519b2ce47e6a69142f0bf26b1bb2f61f8a"
    sha256 cellar: :any,                 arm64_sonoma:  "e82386abd11eb8eb6637b6990b137f7a042d15501fa916d03da12639456820ef"
    sha256 cellar: :any,                 arm64_ventura: "987c8bea9f6115191425ed2266b45223b9d8888aad24db1dbc926e84406119a1"
    sha256 cellar: :any,                 sonoma:        "6b443c4ec326bd9d89227b67d6150bb80c90a86a7565db53649c2bfe2d70dade"
    sha256 cellar: :any,                 ventura:       "e605baf2a5bd2278af781c405a166a59afcdaf37e6fbffaede93634fefc30537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3202ec8424ada79176cc6da5400a1a03396c9acb58f10006547679ff65ed878c"
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