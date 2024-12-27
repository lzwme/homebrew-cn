class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.44.3.tar.gz"
  sha256 "1b68c6d4a21974d5e3c14bf22e067607113afc3ea152b1ec225fe19ffe127348"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1044c61939047537b1ae698dee5ae467572b86beff9c2848a9d135e68e63196d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8854e632a4e95e14b8181b8b040207317779eb9344d8ecdc75808ab2e9cd9ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b8e8dc79c6372dcda21dec16e08e25fc47df6444b2fe1d3df5909b1664d8c89"
    sha256 cellar: :any_skip_relocation, sonoma:        "965330412f65373b144e10d239fd232d3970fb1b18ade87ea70670448cdba092"
    sha256 cellar: :any_skip_relocation, ventura:       "826861b159bdef6b7f5d2787ee9773bc3efb4fb630317753db471ca128822723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "374b87c3719a97ed366537bc3917fc77a1fbfe89501493c9c699e28ccb4e41ac"
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