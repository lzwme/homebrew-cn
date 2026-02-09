class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghfast.top/https://github.com/Canop/broot/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "92f88c6051c8ed7276d43a4ab45aacfe7b0dd1d65b3503d45ba1f9dad5e95cf1"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f891aa4abfb9624e8b3e30b1db6d422f45802abb791100ee5ae1a5f2732100c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9986588148881a4a3e91ae940d293ff0a116ef65854703f44b6038753ad3536c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c780e7350582d280e98ba15a7b7107aa1a4076649a4038a50cbbc9581d100414"
    sha256 cellar: :any_skip_relocation, sonoma:        "d198b44ee3d5629599c25be2e72d18b2dcf8932f9c1df39934554d416faa24b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3bf8c22098c32cd661b95e73490debd08b8ff57ab18b0b7da6aeabca432d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83fffdce809c612c93518ba55cc0be92d4f00e50d9c0d311c7e8b9b9d0a42683"
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