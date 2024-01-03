class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.32.0.tar.gz"
  sha256 "0b9bf4a0dfa8a9cdcefcf18222dba4025379a8fa19190075835a99a507ae3d73"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15251eccd7f3107b50a98cec86b86a3d0b5fa650162f51ffeac2b3d5ed44c183"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5cd93d293b55def3167ec4ca8aaf9dd70a4242b3aa8bd704d5f5c558e5433cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "026311c6e49d148fe2d16a1dfa58e5eb8c725f8bc27a5bb79b7eddd77681393e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b21498b1379114722b0cffe970a8f984bf618ae0f51ddc87ef60a70af84101b"
    sha256 cellar: :any_skip_relocation, ventura:        "46616d49b8922376141508aa14c2500c9caef2ff7097676baa20ef75b63a9f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "58f4cacb1998458f900976225930764818113c5636eafec8289daf32154e8d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2b050ab463690418012aa1f3ede908ace27ddd07f2bf094f7d249a7e6e5cb25"
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
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https:github.comclap-rsclapissues5190
    (share"bash-completioncompletions").install "#{out_dir}broot.bash" => "broot"
    (share"bash-completioncompletions").install "#{out_dir}br.bash" => "br"
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