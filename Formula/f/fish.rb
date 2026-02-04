class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghfast.top/https://github.com/fish-shell/fish-shell/releases/download/4.4.0/fish-4.4.0.tar.xz"
  sha256 "529e1072c034f6c9d21a922c359886df75129c3d81a15bd8656a3c4860993ad5"
  license "GPL-2.0-only"
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e7dfaf05bf1947e4297a1d6093c8f8a4ed68fa4c49605432cdae757f667008b"
    sha256 cellar: :any,                 arm64_sequoia: "e957af401518ca832675d553745a306cc978c43008e1d10ccdcefe70aab2f859"
    sha256 cellar: :any,                 arm64_sonoma:  "007c76afab746fd0040c9c40000b8f08a6bb8c2492dbcf63423b175b4a3eda49"
    sha256 cellar: :any,                 sonoma:        "072e94365bad3e644f1b2f960299c38fe311c586bb22cd4686ea56229d44a62f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d03125ef76629d1ac298a0735f059275afedc5ce6544bc7c7bfc3275c64dfc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb5f8290bc1f77479e638c5906f555cda2efd7b0276ddf4c55f580b4de8f06c3"
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