class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghfast.top/https://github.com/fish-shell/fish-shell/releases/download/4.9.0/fish-4.9.0.tar.xz"
  sha256 "49d86d655cfcc82c7d13d66c6c30a3351600d44b40fb2b6218fbb8fb0e635122"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c4a4ff2040c86f669407db14e0bbe0ffc523f2b3b3e44618f8238868a8174e23"
    sha256 cellar: :any, arm64_sequoia: "d80377e13e5d24d60fed70f4c39db27226b35b97a06ba14c7764ccaaaa3ce553"
    sha256 cellar: :any, arm64_sonoma:  "dcfb86133198d8b857d2f9b5a581c4d2f21f437ba35f40de3b2481c09a8cef1a"
    sha256 cellar: :any, arm64_linux:   "979ec9bc4dd832eb924c14c690fdb3ea8b2ba46631acc0dddf62de9edeb43833"
    sha256 cellar: :any, x86_64_linux:  "45b74ac5dc439dc5af2030d28d1121eddb54c55f8f1e4d15cdaf22bad73fa211"
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

  test do
    system bin/"fish", "-c", "echo"
    output = shell_output("#{bin}/fish -c 'set --show fish_function_path'")
    assert_match "#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d", output
  end
end