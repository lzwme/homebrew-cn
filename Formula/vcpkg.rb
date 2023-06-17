class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghproxy.com/https://github.com/microsoft/vcpkg-tool/archive/2023-06-15.tar.gz"
  version "2023.06.15"
  sha256 "b3fe08760d569a3a16a3dd22f082f45fcfb06fd35ed29c53341f5e888cd2c9d9"
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
    sha256 cellar: :any,                 arm64_ventura:  "63df49a1fb7978baf6842bf26454f6e162c2d76a7f7095ca76fbebe3e18e9c74"
    sha256 cellar: :any,                 arm64_monterey: "be0c3fd8a47baa5d2a4ca0cd95cf1c0765729768384e9f2b026ddeab2f87637b"
    sha256 cellar: :any,                 arm64_big_sur:  "10d13bdef47042eb4a13bdd17b4752fd8dbd9fade0796707159aaf0a8ac0c286"
    sha256 cellar: :any,                 ventura:        "b178dd2c91a62afa49141ebf0c1626b2ecca121038fb130ed545ed41e2cb4811"
    sha256 cellar: :any,                 monterey:       "0421d7581fa3f70c6eccb8b09f570e15a19a9d580ead04630f7647e701815c31"
    sha256 cellar: :any,                 big_sur:        "470198cace67876677b2618d51dc29b01ea0967d3d41c2f402fadbc919f32e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b2c0c0e543edf9f114650fdc2f2ef918749c9cca5a25fd67d6bcd769b5d06f3"
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