class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/v1.24.1.tar.gz"
  sha256 "24196f010ef2dc33e0dd419d66e5e1afc52ae508b5ee6d933aed0cc5334d15df"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25eccd20096d2e6aee29e7e1bb711c8dc28c3c1a342116940fff093a4091324b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ae3be6ec02165cbf940de7b6839ff5a3c2aa57417a4e1771de19ad79ece6ba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92154379ae856ddccf5d039b51782d8529be48fafcce68568aff0c7ba7b49399"
    sha256 cellar: :any_skip_relocation, ventura:        "0735faba0a2fa2a30cd5562aed7ca9c9e590352c883a85f76592738bf5d55d5f"
    sha256 cellar: :any_skip_relocation, monterey:       "3a54c6d4a3e174f2b4f7b7a88b3cc06529b1f15f7cc489f5a57837b9a1330805"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3df5f241e5f823750ea23ff86d51aa6c38b66c7d57172d6c32334c01af6721c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0b04ff2a3ac80b4837428482aa542edd0b3101a2fe0dee0b5c1013bdb6872aa"
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

    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}/broot --version")

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