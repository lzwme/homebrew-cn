class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "3c3e33b3b81510e56a58af358e5123dcb3fa7b636accab92c1b3bdfda448a669"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c405d424f753fa6c6b290f1baae7b378ecccd3270be6576198139f1d4aa1450c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd1b07c04ecc953131a6371098da426e99a32105c9c9dba28bdfcf4d4754460d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "520f8b9b2dbd5c6aabd125a9787437d578107d0c489b77675e9a8555e8575096"
    sha256 cellar: :any_skip_relocation, sonoma:         "15206fdd546912d1532b4ce49cc204c32913b93674a5fb476f3af9b01739fa4d"
    sha256 cellar: :any_skip_relocation, ventura:        "75d52b70f2923127243377e3d129b08a32a3a632d714ccee83ebbf6eb653b7e9"
    sha256 cellar: :any_skip_relocation, monterey:       "ba7efc6b87b6facacd4363b8678f1715af4d716ad873dc3e7a0846b676dfc8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "325c667b2088b5f5ef3884729ed63ef35bb2253e9482a93fa7b72bad58f116fd"
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