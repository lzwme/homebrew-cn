class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https:fishshell.com"
  url "https:github.comfish-shellfish-shellreleasesdownload4.0.0fish-4.0.0.tar.xz"
  sha256 "2fda5bd970357064d8d4c896e08285ba59965ca2a8c4829ca8a82bf3b89c69f3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256                               arm64_sequoia: "c80c84237d87bf967035f6280a53c0f46456cd6591c312a96144125715ef0eaf"
    sha256                               arm64_sonoma:  "34df79081d628dd1d3e8faae3e7d66a7aa9389a4f1e91f6dc50feed7b9f37e93"
    sha256                               arm64_ventura: "c7653c2c30a335fb258797a4e7f76e6fff809d96549e148b6f8b0aa7c3877c9f"
    sha256                               sonoma:        "730165471007c9503b260b3bd22f7ed5536d91f80662cf4c9277514c644f88e8"
    sha256                               ventura:       "56e340b82a17af418c5b1ef6ad0c98fa674faa585eabfd4b2fb07219df77d460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3675238178e72e615a0386f6d2302701d8d4b8b7b0fe499d04bd06636a6c52c7"
  end

  head do
    url "https:github.comfish-shellfish-shell.git", branch: "master"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  # The library itself is not needed, but the terminfo database is
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-Dextra_functionsdir=#{HOMEBREW_PREFIX}sharefishvendor_functions.d",
                    "-Dextra_completionsdir=#{HOMEBREW_PREFIX}sharefishvendor_completions.d",
                    "-Dextra_confdir=#{HOMEBREW_PREFIX}sharefishvendor_conf.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare"vendor_functions.d").mkpath
    (pkgshare"vendor_completions.d").mkpath
    (pkgshare"vendor_conf.d").mkpath
  end

  test do
    system bin"fish", "-c", "echo"
  end
end