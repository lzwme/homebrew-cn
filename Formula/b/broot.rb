class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.44.2.tar.gz"
  sha256 "e1b78354c21680914a07ed4b856257c83ef873b878ef281bd2d1aed7fcba3828"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad3b7b701b0d0b24cc9868bc4e1e575aa89c04be18d8d5907ecd8ee94ef7605c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "861a3871c40abad90cfcf69d9d5e2c309113382c6c876b76d2266ca2eb8979f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f541d2cbce0674f7231d2d9df8653380eaee426d8a9454ffd42fe69bd78fc34c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3378be3f1a9c154a8365ffece2f9e867c152df69de7c7c9e0a2361b4d87e021a"
    sha256 cellar: :any_skip_relocation, ventura:       "582e0964024cb156b9debc17cc4cf6e28ce1b2ed14d556fcef5adddc3f7dc45e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5350a104f339cc705cfbd07bf5d76b58f80d27ec799a8909a6eebd81c3e2faa8"
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