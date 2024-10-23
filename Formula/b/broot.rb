class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.44.2.tar.gz"
  sha256 "e1b78354c21680914a07ed4b856257c83ef873b878ef281bd2d1aed7fcba3828"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a94de1e614521fab990d17d959bb71d2351311384517c7ad0b5e83ef8e1fd04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b4ba173f2232e82fe75e3d3acd846d89af63e6b5cb7b21f1aec992234bb2f19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d68abb5035d1de6302fef8705ea8ff8da8a7604f7e4054469f445dfc00e0edf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "518d3f8ff6274c925f4df10afd26472c54b6af326f83a2f355467f722e90070a"
    sha256 cellar: :any_skip_relocation, ventura:       "436906062760a229b4a72c07402029e64c7c6980e8199f229b3c96b7e709d912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b407acb85b70f6fb9077d67d51ab77c77c537595b7a8fd50e1427c72b45cc6b3"
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