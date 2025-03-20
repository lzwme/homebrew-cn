class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.45.0.tar.gz"
  sha256 "526325b369a7b5821ec0a99504fb11d35795218bbc0bc895444fa2e3ca4284d2"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b78368a543d9780ef99188d79316e99ed245e55c9b2269fecefe87b602224919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2de97698c34550ba72554590a60c428a5940feb6e08158c7399b2fbe4cfe041"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e689af8c0c8c9fe96ca2fcafbe12c0e0ebf2705dd78a6b5fc7bbb20e7fa931c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9153557eb81be698e665ae7b0504e213056138dafd2194f3d73ff605d0d453d1"
    sha256 cellar: :any_skip_relocation, ventura:       "d9c297a63a0edae435c25f45a8c19616e5e0d6dac6f69d8071219b1031295fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d52e2aea147a732cb5c8be4079200cb021e66281f2e5f6b077ed1c94c7cfc06"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "manpage" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y%m%d")
    end
    man1.install "manpage" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["targetreleasebuildbroot-*out"].first
    fish_completion.install "#{out_dir}broot.fish"
    fish_completion.install "#{out_dir}br.fish"
    zsh_completion.install "#{out_dir}_broot"
    zsh_completion.install "#{out_dir}_br"
    bash_completion.install "#{out_dir}broot.bash" => "broot"
    bash_completion.install "#{out_dir}br.bash" => "br"
  end

  test do
    output = shell_output("#{bin}broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}broot --version")

    require "pty"
    require "ioconsole"
    PTY.spawn(bin"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
      assert_match "New Configuration files written in", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end