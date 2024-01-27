class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-01-11.tar.gz"
  version "2024.01.11"
  sha256 "36590cb374eec56e3cc6ec49a3afdda0ece1afb81011a06c8c52da3fd017f8a1"
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
    sha256 cellar: :any,                 arm64_sonoma:   "d55d01fc6c0e69943c370a40ca4b0c78bf678f48d429f096b1542e1ef9c370cb"
    sha256 cellar: :any,                 arm64_ventura:  "11d305eeaedc7ddb7cbb59effc28dc6e11e2511cf923456558a82cf43da71b3f"
    sha256 cellar: :any,                 arm64_monterey: "60dd5ccd1d05e00f07dadc1c3b7fb42a6680afcd7048e329766176b192b5fad5"
    sha256 cellar: :any,                 sonoma:         "6e6fc3715374eb2930b11ad5b61c9a43c6e62b16e28e5dec1fb52cba94dba07a"
    sha256 cellar: :any,                 ventura:        "53515204ad1f15e2b403d9db95b7370f7f95d0bb8cb5dcb65764e31a93449122"
    sha256 cellar: :any,                 monterey:       "5f35d36104da612a7b83450f61fa2892403a9de8d2342d2db628752c5e3f36a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af104f763788a68bd369a5863b0c7c1e5197bf2d6f2a6d74ff8f127cdfedc4cf"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "localesmessages.json" do |s|
      s.gsub! "If you are trying to use a copy of vcpkg that you've built, y", "Y"
      s.gsub! " to point to a cloned copy of https:github.comMicrosoftvcpkg", ""
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
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
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root."
    assert_match message, shell_output("#{bin}vcpkg search sqlite 2>&1", 1)
  end
end