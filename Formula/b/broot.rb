class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.30.1.tar.gz"
  sha256 "ce9defabcc44df97d0e088572bc00b51bb961b451d45f31dc1e57512d2515739"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc5c6abdd4c864cd71507bf68364d6ef8c9682787d27d3187ec3723a3bfdc3da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f7e9707be13bd6810f65f5ea17bf90db78bb273f1057c5b90352e232e9a7908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3a43643013977cc325cc7cfc3520d80c476c700518a8350ecbedfb58cb83ee8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9bba695ed0cb763cdbde60cdee4c162e6e585adc8609946cf01048edde8dec3"
    sha256 cellar: :any_skip_relocation, ventura:        "b86b11840589e196bdfdb246a02bf55ba81c67e4012bb043f083ee59eca9772f"
    sha256 cellar: :any_skip_relocation, monterey:       "1b9255251f3db05cc4327a06bf014b2f87c384fe071a929c70c1cb2fef934e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90a82f86bb22476ade9d08f1c539175bd89b7c1f0e1b3116e3d1427613ed38ca"
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