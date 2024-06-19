class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https:github.comleo-archclifm"
  url "https:github.comleo-archclifmarchiverefstagsv1.19.tar.gz"
  sha256 "98fe9a1d26b02d661440787ae811363c97da537a11fd3df78ff98d40f42dc487"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "566d5eed9e988cc3d76bd16f985ab4feb47da1a6bd2b5d29ad71836778f722d9"
    sha256 arm64_ventura:  "ca870dbb89899a9ec44a161c53a171e5e36c75689f8a79783717d5283793e566"
    sha256 arm64_monterey: "3474dba76e59c7cb5cc89010807456933f21fc3eebe7a6479e9c37c204b0f164"
    sha256 sonoma:         "ad385d76482e49975bb33f81bc5aaa2ed8996234ddf9b871a34fd7b0b46ad493"
    sha256 ventura:        "9047512f207b137254029c2e50fb8f081bf25c4c801ce243528a7bf36923234a"
    sha256 monterey:       "91deb6b2ed664e62d4c39c9f7d1008a7ec2797afe103d136276e24e42cebb30b"
    sha256 x86_64_linux:   "c16f1032f1eb86e95ee9f49cb0e4960aef7b7dba0380f5cc30a165fb63b44d06"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

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

    output = shell_output("#{bin}clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}clifm --version")
  end
end