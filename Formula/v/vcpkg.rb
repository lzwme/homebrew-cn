class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-02-05.tar.gz"
  version "2024.02.05"
  sha256 "b816b7f49e8277ea7bb34ec836f7c24d6364e25cc9c1a128f84084d96d2760ad"
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
    sha256 cellar: :any,                 arm64_sonoma:   "91cbc0344c97ac192305e670e5d69b14cc82be14db935acd6905335bf5ef0645"
    sha256 cellar: :any,                 arm64_ventura:  "8b968675b463fdfd59f02ef6c5fd7ed8f29909a2a00837229f135e0d6581fbac"
    sha256 cellar: :any,                 arm64_monterey: "8e24b7d56361bf8563511ff9c95dca7f8e10dff1658ff2b44f508bebb7441ae5"
    sha256 cellar: :any,                 sonoma:         "e10a62e85acea64525763428b8f8c5b3e6f67156f49d5a4c34595c5d5da76b9b"
    sha256 cellar: :any,                 ventura:        "0f6edfd374ee35a066482445f2e0417b4dbf3f841e0cb4439fdc4f4a4f52ede1"
    sha256 cellar: :any,                 monterey:       "27ba82d8940a96a88c5289c58da37d955570e02e37acb931c9f9a5f8ef1846c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21471d7e952c827901256622c35c84997f8fb77d8ae34afda6b9c929cd88abdc"
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