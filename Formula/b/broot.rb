class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.44.4.tar.gz"
  sha256 "bb58cc469b2637cc49b1e6d308174c3d690d96ed9537f6d8c38f26ce539c8363"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e7211cfa3f0d2a93d51c35355f5dada46f670f09dcfb644f92534a304d7e7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a293df273aab73f5202ee7dd3d8fe475ba7b914a141419b5ece0850bb02ed311"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf39d31ec0cda36d52a7f5f028611777bf99f571ca75f440130d074bc924901a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d3048da939b2a9a0c5465cb55ee5901ed402f851de8ae1940bf369c323d01e"
    sha256 cellar: :any_skip_relocation, ventura:       "3119ad04c2d6bbeeace673651f37e97297a57ed574bc9a3c2d0288dfc54197b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ebc56605e525cb60b5a9a5d4387a783923ca6e2ea4c20dcfbd2c5dded9d679b"
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}broot --version")

    require "pty"
    require "ioconsole"
    PTY.spawn(bin"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end