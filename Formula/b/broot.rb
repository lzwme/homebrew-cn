class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.43.0.tar.gz"
  sha256 "64e1b4e2c57373b85ef358241655739f5bb8dedd6600ce0347a6b40640614326"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5be8c784774d8a9ca924a8333f85b86e5c4f7da9b021cd989c709d5947f7025"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be41810ef4afd184275bcce13b543a1a92263f4ba82788ff83b0cea32f4beb8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4ba8276421d3e7d8007586625070a36253e34fb8bd9fb51fa2c470c0f6c6a37"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c5fb2db8e8e2853ba44bb9b173f0e5ec769896e042763ed9114eaf2288daae8"
    sha256 cellar: :any_skip_relocation, ventura:        "f743dd0f843219c76c7ddf56b3bd1db8e659c2512338692ef0fc2682a9a560da"
    sha256 cellar: :any_skip_relocation, monterey:       "004bfeb472ec1cb73a5bde11333b55d026e595a6bdfaea333670e52e9f7ee81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8382bb13f47ab33fe5874149e8a3b29c873c235e5211e346d918d7426d3bd002"
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