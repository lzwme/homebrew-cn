class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghfast.top/https://github.com/fish-shell/fish-shell/releases/download/4.3.1/fish-4.3.1.tar.xz"
  sha256 "78f8881b971ab95ace5f2a9a25efef66f6c180396b2085b9852f21f8e4a30408"
  license "GPL-2.0-only"
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0ef548e71518423b84603b87b54922305aa6634df389ee9a85f6a104ce955b3"
    sha256 cellar: :any,                 arm64_sequoia: "5e8f55da26e5f62c2a5237a46269520920338aacb08fb3be68d0ae6b1e76d3e8"
    sha256 cellar: :any,                 arm64_sonoma:  "afff00ccdf6e2b400f33ab0967c17f4dd9b6e4b815573356ca757eb0774c008e"
    sha256 cellar: :any,                 sonoma:        "7b5d7e4bac532c5eb8ae8a77708d9eae69d9cabde6b49e0f44f673b119dbfc85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "479800bfaa65a0fea197bbd1f463f0dbd51ae98eda891598ae5f5f1c44f21d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ded18df83791cb68a975eb59b4ba2c6095168644bb1289a7961db48b6172481"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  # Fix to respect our extra_* dirs: https://github.com/fish-shell/fish-shell/issues/12226
  patch do
    url "https://github.com/fish-shell/fish-shell/commit/a3cbb01b27a7e881d5117688be79e19e1684657a.patch?full_index=1"
    sha256 "06d3d04cc44f52d22a0179233a406795cb43392894ebf1e604bd6e53bc12ec0d"
  end

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