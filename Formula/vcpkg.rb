class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghproxy.com/https://github.com/microsoft/vcpkg-tool/archive/2023-07-19.tar.gz"
  version "2023.07.19"
  sha256 "74a29d0ecd1801bd0cabf3dcf0a29e630ba110c50ed2919da121380193633d66"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3acbd319d14febcc2d8b56972896809578962da6512c9ad0eb694c0db9694b62"
    sha256 cellar: :any,                 arm64_monterey: "81c90a590fb1c3f04357c7fce66f804b3b7f29207090366ce35b7a32db10226c"
    sha256 cellar: :any,                 arm64_big_sur:  "51022dc5f56593c943e27f967f0d502862b0a9e021fa20b1aeca996794969344"
    sha256 cellar: :any,                 ventura:        "70ce6ea9b7857dc3535f5f3c7c9258ea7b00570d16e10bf0a657993a8c2a09e4"
    sha256 cellar: :any,                 monterey:       "eabefc707bfa0a147fa96b631c61467f6bd86fe6167310678c6d13cde4ee321a"
    sha256 cellar: :any,                 big_sur:        "e60758e3ec0d1c56476598d997b410fd916a639a594187f2588a732b668e8c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7b6b00fd48fa72c37f25c127f8dba8117f906d50cbae4e9a6f01c0642d9434a"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "locales/messages.json" do |s|
      s.gsub! "If you are trying to use a copy of vcpkg that you've built, y", "Y"
      s.gsub! " to point to a cloned copy of https://github.com/Microsoft/vcpkg", ""
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
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root."
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end