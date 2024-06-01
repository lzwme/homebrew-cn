class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.39.0.tar.gz"
  sha256 "d1d2ccc11543ff4ea645d57a5e78639542a6f510b585a78c31ddb3a24399bf61"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a84a6211e4229f1ce856181db3736217f9ecf8f63b932d9f740c6a9d51c56bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe155596f7918cd1a00014a3173ccb77a5a903b4828a52f8e353898eef9280c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "394560cee60dbc2fba018365b63aafcdec444b6d2beab64b4fd9095671ec20b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "90201d3ef3b0365ca8e9ae1ab9b77549b9dd6ad8cfeb4e5c5cdac6a08b1b7d33"
    sha256 cellar: :any_skip_relocation, ventura:        "ff43d30b8105827df76c78adf9abb63fae021836e26090845c67811433161c26"
    sha256 cellar: :any_skip_relocation, monterey:       "eeec145ebbe4de510ddce9f7841a763bc2372ede3310f98019b102e9002dda13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa6545662a0e67c2b60d6ddc2bc25e8a21369f005e7b144d02f21ba3d3d1b0a"
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