class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.39.2.tar.gz"
  sha256 "69e565d7b1620dcc9401e8b415fcde84893d640541f7b534a55869b9c1cfd387"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d28455c2d6e298a9e58aa10be9ead1c1317befe9dd8b291f13dbd7dcebdd9761"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c03778677f8a63801abee89da0e1c70b73394859bd647e24f67602c257193ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d338ae276d7bd87fda3a85caeeeae9a0d9707c58fb08b0c6a33eae0eac4dc674"
    sha256 cellar: :any_skip_relocation, sonoma:         "e16c7a5bb856ceb32314f5d6c94e2106186290a3f2d34aee3e1a2d22c363d543"
    sha256 cellar: :any_skip_relocation, ventura:        "21963b088fcdb3e278aff28fc498c89e4f92dd1838db944c451711307d2e32ee"
    sha256 cellar: :any_skip_relocation, monterey:       "91e03e289ec20e6870f732eee1b4f2b5b39345f6285501ed49506a0b40d587b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afaa978ecd129a9c648f8aeb27f8e93cae55e3a4dc459cbce3c2141b7209c3ee"
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