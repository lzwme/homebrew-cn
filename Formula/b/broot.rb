class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghfast.top/https://github.com/Canop/broot/archive/refs/tags/v1.56.2.tar.gz"
  sha256 "3e7be4252c76565f6d71b34bd07d26e1444b9ac2e1c8271c724f6e866fe75565"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f2c4d66083294b14dc65242efa350a2350a90e0211e475457561840d3613ea7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22fabe8fded7f153657a67506918252f81fc18365b4ca4a1f1476616e9bb33d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58b2199c594695a9003b7e034393f31bab46dba5da94d837d120d15f8de2770e"
    sha256 cellar: :any_skip_relocation, sonoma:        "505393e6ec36711156984a5c8910545dabeeda1f041d93e387bd2b2ecadf1ad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3985735018a7aaa65e72544d3a0f66d6ff28d43a5efb2c171fafa569e28a65f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904eec43923040d62604c9c71c689e99537bea1f994cbe3e62c78ae7f8282f05"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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