class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghfast.top/https://github.com/fish-shell/fish-shell/releases/download/4.2.0/fish-4.2.0.tar.xz"
  sha256 "6c43be5a9274963c06ba4cd55a109dfcc4d5d3a8054ed0e0a3666388581ec252"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7efc3ad02b3eddac5f75b7d45d642a56bb4e4a021005f50493489df8f5b162be"
    sha256 cellar: :any,                 arm64_sequoia: "3e35f1af55913fe486cb0b121aaf2b3e89b2190e0277dad8d3191340c3c698be"
    sha256 cellar: :any,                 arm64_sonoma:  "22a26c5dea5b32f4d372bdca2f87b9b7cc8fb48eed13fc98a039a74400703c40"
    sha256 cellar: :any,                 sonoma:        "ee9fb1307e333b1cd8c7b71c921e82ac32408bb592f868efb213e9dd006f973c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a0368f14e7fc63aae7413476e054701d62eb9f352339bfbf00719f2be7f5df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a981fd5f13af5a336ca42beaf6312650978cc638f24160490984ed564e5f6e60"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", branch: "master"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d",
                    "-Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d",
                    "-Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system bin/"fish", "-c", "echo"
  end
end