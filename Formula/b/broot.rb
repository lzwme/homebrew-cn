class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.30.2.tar.gz"
  sha256 "497258f593ce6998f9a85369da87149ef1777313cd404dd83a46440dfff15943"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "202b9fcd1638b700472d75e5fb7f490d2646ee1699fa9af15f1adb4ddf246f9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0328cc1090cd25d6b83370466c7b2fbdcb620f3e14d8dda4277876d034548f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23faebec5ff4fd6886a2ec06fc537287b7f5ab9a854816f028d09de761e7eb52"
    sha256 cellar: :any_skip_relocation, sonoma:         "92da7efc7bc0087b693b719fc0c77a2fbb6cda97de600ee696ef1e91e0bfa87d"
    sha256 cellar: :any_skip_relocation, ventura:        "66d6783d5d944e300c5207359031b0f0998b65e588ac0802e41e923f3ee5875b"
    sha256 cellar: :any_skip_relocation, monterey:       "faed9521366bc95536e300ddd533e8a3752021e471907343982a84d4706e7046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ab5524db1c8223fee5695cdf8141fb8239e425153d24eefaef0be426b1148eb"
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