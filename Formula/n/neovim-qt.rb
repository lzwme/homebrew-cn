class NeovimQt < Formula
  desc "Neovim GUI, in Qt5"
  homepage "https://github.com/equalsraf/neovim-qt"
  url "https://ghproxy.com/https://github.com/equalsraf/neovim-qt/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "b1e1e019946ecb106b3aea8e35fc6e367d2efce44ca1c1599a2ccdfb35a28635"
  license "ISC"
  head "https://github.com/equalsraf/neovim-qt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c83c58716edca89d93dec4a309628a4abee57a834a7d2e55e60bd8f1337101c3"
    sha256 cellar: :any,                 arm64_ventura:  "97f6a46655c99d48e55fdbd825b7c41048654a5c8e37399444dc9ffc1c4cc9ba"
    sha256 cellar: :any,                 arm64_monterey: "cc67e416a0c7b0b32c0687e20c6343216925f7402b0cd0a293bb5d33cbb8f356"
    sha256 cellar: :any,                 sonoma:         "d7f7d75a951797a4181052c0316599d72e30cb8bfb10e56251b6b22fece92aa0"
    sha256 cellar: :any,                 ventura:        "a82123756bd0178b09e41741a8c10a8c2745f86cf46d9fb82bafdb1d9738f4f6"
    sha256 cellar: :any,                 monterey:       "30da4655952316b0fc93eb7cfe14eb166960693f03ef8694144bab097b304391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c7422f89ba1faf954bd679eb71b7768d0dc413fe802a373cd330cda4a3c72d"
  end

  depends_on "cmake" => :build
  depends_on "msgpack"
  depends_on "neovim"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DUSE_SYSTEM_MSGPACK=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install bin/"nvim-qt.app"
      bin.install_symlink prefix/"nvim-qt.app/Contents/MacOS/nvim-qt"
    end
  end

  test do
    # Disable tests in CI environment:
    #   qt.qpa.xcb: could not connect to display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # Same test as Formula/neovim.rb

    testfile = testpath/"test.txt"
    testserver = testpath/"nvim.sock"

    testcommand = ":s/Vim/Neovim/g<CR>"
    testinput = "Hello World from Vim!!"
    testexpected = "Hello World from Neovim!!"
    testfile.write(testinput)

    nvim_opts = ["--server", testserver]

    ohai "#{bin}/nvim-qt --nofork -- --listen #{testserver}"
    nvimqt_pid = spawn bin/"nvim-qt", "--nofork", "--", "--listen", testserver
    sleep 10
    system "nvim", *nvim_opts, "--remote", testfile
    system "nvim", *nvim_opts, "--remote-send", testcommand
    system "nvim", *nvim_opts, "--remote-send", ":w<CR>"
    assert_equal testexpected, testfile.read.chomp
    system "nvim", "--server", testserver, "--remote-send", ":q<CR>"
    Process.wait nvimqt_pid
  end
end