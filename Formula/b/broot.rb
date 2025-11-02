class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghfast.top/https://github.com/Canop/broot/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "2f0c9b52a97cf32f617e39084bfff8271d4a3d9b30f8ec2811b577cb433d7743"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c55326883899ae579cf45a22d5543b96706fb3b09c83895c86affbf18781153"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42795f13ce351a096aa305fa19676cafb154f4e301850612d29d008974075653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0179a500ad8a7e3fbc5b2a0db395d64dd0c6cc502c7b6315325534fa42794bae"
    sha256 cellar: :any_skip_relocation, sonoma:        "46269caaad596ddcf9867a08bd17f636f91c8d9c697fc25c3335801e019310aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dabf704921c24874ed243d6f0e3458dd1277d95991501d492940f98ca722993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "438e5b147341337335c99d4d8d06dbaf9b91e7dbf29f874b28176ee6a0a3de25"
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