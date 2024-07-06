class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.39.1.tar.gz"
  sha256 "b186eaa995a50ef36f0d166104350e4f5c1a0b74cbe7ef101eb16b68fb028cdf"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a136bf91e07cbdd7b8d10353f1891e5b181ccec4bb0ffa320e6a3a1776af445"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "602135f7b67cd27bf20db11d501dba7ae097804ee1ce12544e3ffdb866f2643a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b14d1939dee5d1b1c89be456ab5e4695d3e98821d4d266b7801d118986832e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd77b9dd5e0be5fa96225239db73b2b738500d1a2f375e66cf5823030cbd79a5"
    sha256 cellar: :any_skip_relocation, ventura:        "35ab39a3cbec1fdd7dc3c48fa6fdc91bc5500dcaf3c038dd974a300cbc118c93"
    sha256 cellar: :any_skip_relocation, monterey:       "7307af50a5310d9f7b87e197411b6e9e6b06e322351613c39d6b2eb76bfe00d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25599df499311125096d45f7d303c86f6accd584b32ccce9cde4453fc9e45351"
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