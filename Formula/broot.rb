class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/v1.22.0.tar.gz"
  sha256 "67ede3773a7cc6f36885c0670872da556811f4de90e4d348fcb7e068139b51bd"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8582be19d7a34cc40bf6085c731305b7ac321483329622471c34119fd7498623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45514ac3bfbb0fa089374bc9b1dfa6b99f6183762f1edc98b986648f66126c3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49e01b06130b02677f7e2cdf518e6d9c666c5c44124bb89e9b9bb91cdb032a06"
    sha256 cellar: :any_skip_relocation, ventura:        "7c3159b64b4c5c791d2927444aa4c05dc1739b7b0838f594d54523399aa4eb29"
    sha256 cellar: :any_skip_relocation, monterey:       "91cbaf00968983690d0c4c2d83e31a47e080e89b4fec7c6648e3bca4483f78bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0fbc42972e0eee9d4fd6059cb1359a63f6d850abda92aa44e573acb43bfac89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd94aaac68bdf85f240eaabfffbd197f9363765e59add870f98b80eb45840bb4"
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