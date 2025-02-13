class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.44.7.tar.gz"
  sha256 "8f21782b0b2f4c0ebcebeb161d8b163927d7f272c44c1c37b2af3640c5c36fc7"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ab034afdc202ae7d2cf59e9d0273bc95f356e1d20e413ea94b273c2b90fab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be30bf447e718aaa02f8da2337efe13b5bfa9c1c33f984530a147946edfccd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1d2dc42d323e11c82a27448a929a1679a3952cc3a6bd2f431cf9512b2da6889"
    sha256 cellar: :any_skip_relocation, sonoma:        "648c5ec1acaa3d15b1d3b0b44e5765fc769af0fd47769c1c1d7ee7e5d79422c6"
    sha256 cellar: :any_skip_relocation, ventura:       "5744ff586bafa38e12b535d2f66da1893c980bf8b3451a920fd2d790cd115d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14b3c917e27838632a58a6afc784cccd5b446adaf22eac63d6bb1b3e24a50957"
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
    output = shell_output("#{bin}broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}broot --version")

    require "pty"
    require "ioconsole"
    PTY.spawn(bin"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
      assert_match "New Configuration files written in", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end