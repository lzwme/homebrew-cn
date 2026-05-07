class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghfast.top/https://github.com/fish-shell/fish-shell/releases/download/4.7.0/fish-4.7.0.tar.xz"
  sha256 "c54a3b8cb765d3d4a452f3ec600f07dfde9a6892f7ff568fe064071d27aaa9db"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ff808778838c35eb5e5486d7a9b2832d7432dc2427c443fe7b8d9604143bbcb"
    sha256 cellar: :any,                 arm64_sequoia: "8c799cb45a5cb6b450269b4f7f2c90e41af39bbdf6be8e8bca768e1e78edef88"
    sha256 cellar: :any,                 arm64_sonoma:  "41890a36a61951af80e541afc3b16a641436afcec8b0ea2b6fa7889fa9f26c06"
    sha256 cellar: :any,                 sonoma:        "179bd9daf492f47a0e4a4776595227caeaf9105054484d01e005c2ac47261e0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4acebbfab6ff1eb6e7cecd58506e68e975def511a5bcb6fe9774685ae2bc5907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f17ebb64f5174252ecee8baaf05009d34302e2a9bf1bb8086a22fa5d5e76fd6"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DWITH_DOCS=ON",
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
    output = shell_output("#{bin}/fish -c 'set --show fish_function_path'")
    assert_match "#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d", output
  end
end