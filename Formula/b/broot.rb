class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.40.0.tar.gz"
  sha256 "2b3cd1b01a71f102e5f26836afdf2b6ef24e02ecf7c5459cc9863e2e670a27da"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1be7cf782a588140cf17c9bdc6ae6c3694e7e3e754b762e60b23c218c5bc0ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea1680e06ddd9ed41630d9ccef8f0808875063ab5a4b6cf125dbe8e2a929402b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc864cc97bb455414574dda6609640a92275380aac664e7014e3f9547772409f"
    sha256 cellar: :any_skip_relocation, sonoma:         "258485051f34c9e1501ee9e73b92a09c9861c1fe663f718e0dac3eb3efebdcdb"
    sha256 cellar: :any_skip_relocation, ventura:        "06b97985f4dede37735e0f8b8601f1a466df7907d4851c074381c7c316846bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "86f95501737ac936b6f2d68923cfa76fb075c333455a47fe7224bc6e5734180e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f1fef7f89913d1ca1923a7de6dc1a04352d73002092af454332a72e3929eca"
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