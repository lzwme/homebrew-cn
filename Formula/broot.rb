class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/v1.21.3.tar.gz"
  sha256 "6c612c596e467e610c7a80b4f086d9443e2b5040edcfa1bdda129aa715bb64d9"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29131b7c6c0f1704da9eb80f1b2fc5319209f96f1bde8f9270b7704d0bae0a85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215c8f0199add65b8adc5a3c615e4cfd0a12357105529c23853fbb5c1f09520c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a60e06cedbd497460bcc524dd64dcc4ab816ee216d9ef77306812f654c281ea"
    sha256 cellar: :any_skip_relocation, ventura:        "e087a69c3206edd45125d6ba3b3f2bfa0bfe09a3e6f8e86b62d7a0d625482a23"
    sha256 cellar: :any_skip_relocation, monterey:       "46322de7eedaacc64b89a8907c773be005e80c3e11d2623f6dfb1a1ae19559d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "77164ca2efd15f9fe64e27bfed7e799a78c2ca36cba34fce606060d261987b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f8f5bf2b13c251e41511200685c5d55738cd4140b1f6f6be00da0e7d827f21e"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end