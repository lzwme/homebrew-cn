class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "11309da9ff5413e5cff4a9d68fe47a45870fb7225246becbb0dde925cb4b41ba"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41ff11acc7773041313000bdbd472ae4ff61a793136b3033d4669be86b87c492"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bebf9051124b9be7792e7d1d093b7cde355564b90a412547ed0d3f9d0f2f8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de6892a4e0e3e82d4b4c4c90d8327d393c1970841f40b3aa37b37c7727075cf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "794f47a02b616b9dce838ce8b5c873acf5f13fb622c70e27b75d4a186b95122e"
    sha256 cellar: :any_skip_relocation, ventura:        "ae6886f05ee9219ac0fa4aa62804857d15bc39127ceeba1879e36f7d4c3f10d1"
    sha256 cellar: :any_skip_relocation, monterey:       "aa0dff516ced67cac271f7f1c3fa7002b5677659a85a5398aca5f8a96adb400c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217b5a796e31ff1d1bd846b172fd48066de21844c5d8d8563f745a252c59795d"
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