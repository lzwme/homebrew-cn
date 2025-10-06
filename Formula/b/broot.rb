class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghfast.top/https://github.com/Canop/broot/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "66099aa66fd1b41a30b20e9c20a24b30ebadba78a68527ab33debdc9b119b6a1"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a986aaa6b2ac562ae74872715ebfab517ca3869baca7c5ac861cf3ad4a1d798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "542baf4cf93b22c294cc8d247e6e626bc7dc2bcf426c5f60c46d51fb0826cfb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d260e590e5490f7e5cdc8cb67e93af9179145f84e38e1cc8cde5cecf90a37dd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a5c614f0f486c3f95515aa3b90b5664b3371a68ee17232aa360b5988a4fa56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45a5c1a0f22f360bc992e6b6ca7cac54e4c05b62890de308459db525c2c58884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4315e90635404504862cf2a920d20e09a315fead3d04b27c91f900a95db4ee1"
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
    bash_completion.install "#{out_dir}/broot.bash" => "broot"
    bash_completion.install "#{out_dir}/br.bash" => "br"
  end

  test do
    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r\n"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "New Configuration files written in", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end