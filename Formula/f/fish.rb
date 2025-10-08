class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghfast.top/https://github.com/fish-shell/fish-shell/releases/download/4.1.2/fish-4.1.2.tar.xz"
  sha256 "52873934fc1ee21a1496e9f4521409013e540f77cbf29142a1b17ab93ffaafac"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256                               arm64_tahoe:   "522ebefd01e47d714368b9872b46ba1791b580fe5acd88caadb0c92f2273d483"
    sha256                               arm64_sequoia: "7c180ae437fb7c0a71f9135ae87cbfaec7af7f7a7658294071fb3f30bbf456cf"
    sha256                               arm64_sonoma:  "abb89a295c051cbf5bbee6a8b7d031e62c2a0bbe29867c9060164bcab7f27afa"
    sha256                               sonoma:        "19b7023040a1a1741545b13368188ddc4b666a2f0fee4a2e28bf67bca3185b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb3e080c57e8cf057d094459f3d03c160d7aff7d05644ce4695c5f7ce354950d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "134b1366f068a171dbdda51cf0283423085d5cddcd32ff01894abe2aebdcf9bb"
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