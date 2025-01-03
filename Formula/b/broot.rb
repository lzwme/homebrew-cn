class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.44.5.tar.gz"
  sha256 "b8e46fc99c0444bdb7a13c674901cdccc7af7c3c2ee54fde1c901ce517885a47"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22f26bfd9b51c7160b837e8576c8febcb596f7aef3e2abdbf978d95069226250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6640d8ad9fcc9a79ec2611bbf9bcc5a278fe77623eeba87d79f5e38f3edd4aef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91e781e3abaa63a5a84b247bc744df1095ad85d90c12d58a1fe95dc7fca62d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "edd1f0a2570ed892dcd1c75fa7b15d1860eef657c669516aeaec3155f509798b"
    sha256 cellar: :any_skip_relocation, ventura:       "001ad15a67b686ce1ade72d9ac4e97dbdebecb75dd591846f9a0959a3e68d235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d94788d972fdb68d729afd62814b1c80de0df8f2dedf560a264130350feeda"
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