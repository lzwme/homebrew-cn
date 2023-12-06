class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "e398026e20705e9738bfce79f2a0ca79fdb76a177371cad5788ed58c41161359"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b7f74611b986c4a1a1deff4b058f6c32d65ce10db8fed887b580e573240985d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ae2914e9858c7559bc9b20ee6311d3efd0541a609384dbad1ce6434939d97a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e00f8bbe37acabf33e5de2208279dab294d32833876ebd3b5d3467f73e084073"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bd397fb39e541a19e57400e87a59a375aafb060e5366697cc5e9887ca26f03e"
    sha256 cellar: :any_skip_relocation, ventura:        "212fad928f2714ab8d6e51a06f8f9afdabda9b82d41783f4a3ba0bf942917395"
    sha256 cellar: :any_skip_relocation, monterey:       "22ae914e2d7982fa84cc5a4b18506a965841777d58cb62e42dfb35c3de1ce227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e807506a5d03965ebfa3072a50c39f4e07109167b862f1bf34148ef9d924e549"
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
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install "#{out_dir}/broot.bash" => "broot"
    (share/"bash-completion/completions").install "#{out_dir}/br.bash" => "br"
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