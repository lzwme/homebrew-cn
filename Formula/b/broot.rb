class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "e398026e20705e9738bfce79f2a0ca79fdb76a177371cad5788ed58c41161359"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4879bbeee97dc553247507b38e94fbcc1f3e2b077b893b48ade495753c0e20e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fb341cff0b1a265a48bff9f74dfdc68fd738f43fd310e2698dffe46e633c0c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7148707de6fe0ad2aa2de915319779a27b2151cf2c9052c171a84ae50e88cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "51297e5a8c0030808791d36879f729264dea65d1dd667f746dddeec184d78e8e"
    sha256 cellar: :any_skip_relocation, ventura:        "46c59694416b5350d57b868f555e924a6e9f41d711fc41e051d5c73f4f288caf"
    sha256 cellar: :any_skip_relocation, monterey:       "0a9276b984e2d962a3d3500af1870c73119b28fbcea79bafa45d67ae82b1fb3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbe7840e3955613a6e0d2c4032594b353809ec5feedf887772def0a522a5454f"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version.to_s
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