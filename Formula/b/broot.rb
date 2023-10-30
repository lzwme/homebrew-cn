class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "bf4df0d933efbc2093855c4be3d8bfed29c612a57d14b853a3c729e917505728"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "111d1bfecb0aedab492949020e30e383a06874450324698881b83599a6c8cb71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b0ddbaca23d6d1074d5b39e7a0ff0accd4ffbc079f1ce18a5c6a61e0a55926d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf630f7c0df50e7f30550a16642909f6262b92d054a5ce211b36ac36255a073a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8a1929433a283ff00313aaf1f8fdc795ea2dbf198de53c2b632c530af00d3e1"
    sha256 cellar: :any_skip_relocation, ventura:        "7aa331c6ba7fe44c11d9a72a93bec57ee35aa5b85017986e04f01b9165bbca5a"
    sha256 cellar: :any_skip_relocation, monterey:       "693a053a813f216bc2020f18b766a6dc8ec17da7d7b32e172ac30b2dbee023f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee717af36d13befea43567fb27a51c45463938f552eb845c71153e8dc2dc6a2"
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