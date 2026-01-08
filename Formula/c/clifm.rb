class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://ghfast.top/https://github.com/leo-arch/clifm/archive/refs/tags/v1.27.tar.gz"
  sha256 "bc179e706533831ba551de28834fc61024a4c843440326bdae850f8418960d38"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "2b905e856c3e6aecfb34ad6debba847f1ec76ea9cc05b5c216b155c61c38a67b"
    sha256 arm64_sequoia: "59742bdb04cbb24f56bbb8f85268c923f2fbe0da6a56bbf04c5d57b47f3b22f6"
    sha256 arm64_sonoma:  "3d964f81be93be373a5fda3096a2708af2b679854c30e24fc7ac2a2e59086e6f"
    sha256 sonoma:        "9ae8a2f8363d0027bf2eee06343981b349f678b6b367096cfb639fecb57ca22c"
    sha256 arm64_linux:   "e258251a9685b7c05fc40e36e0661b9c066744a3f73588effc8e204443a08fb2"
    sha256 x86_64_linux:  "7aaaea057666fe0c61da4a5a1aec365ae38b2b46ca88c8e5da5a43f50d85cac7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libmagic"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end