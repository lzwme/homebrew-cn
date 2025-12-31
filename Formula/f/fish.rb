class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghfast.top/https://github.com/fish-shell/fish-shell/releases/download/4.3.2/fish-4.3.2.tar.xz"
  sha256 "36a09cfc7fc2d1f1d0b6f5caf3828998621721f8c60a7a31ec55679286a9fe1c"
  license "GPL-2.0-only"
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ccdae85617de43722cadd998417d307eff399c8421b715305b67562b5889fd9"
    sha256 cellar: :any,                 arm64_sequoia: "84daf68777d0464cca7a1b23e862aa3d619df031aa9da7a8365f3b4707f8ca01"
    sha256 cellar: :any,                 arm64_sonoma:  "e06f02a3d1afca9df5ac2997dc6aeb68ccc80ee1d88901c8ffea57c77c024feb"
    sha256 cellar: :any,                 sonoma:        "886f002b74d9c1418d7f77392900e110cab3619e97a1c9c6392a77a69929acb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54b437171109ac9a4259cb432deef5c703892df9f492bd8b91b13517e6f8095d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb216be580eb43f11398fa5d07ad8de6ba4b0eff8822c0c08112d8aa3e4a0f24"
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