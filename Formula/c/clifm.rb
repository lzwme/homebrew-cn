class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https:github.comleo-archclifm"
  url "https:github.comleo-archclifmarchiverefstagsv1.22.tar.gz"
  sha256 "fbc92437c41f414e2f490b65caba38b8aa62bf95cf116812b466532bf85e0201"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "ade1dc0cc7713d960bfdc72b9f3e2a0f5203f211590c61bc0666ab6bc2e38d2c"
    sha256 arm64_sonoma:  "507c7615ba80bf0b01acd79a598a1d790309c68d8446aa0c7b0d8c7823e7c273"
    sha256 arm64_ventura: "bb1a23b1802182397a417c8385553394e61dbd9c85c830446d4c099c4255c09b"
    sha256 sonoma:        "2b7ece885d9ee25b8b9ed48eb661f22d11f4da765372c552eb1722c7396c6ddd"
    sha256 ventura:       "35137fce493c482238f7d5eec9b4e10a792e3d7877868338035656fdbcc0a83e"
    sha256 x86_64_linux:  "55a52c7e2e012b3eea3c0b821d14ec9b72d27b0bacecfa4b6e87a33ab8e90948"
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

    output = shell_output("#{bin}clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}clifm --version")
  end
end