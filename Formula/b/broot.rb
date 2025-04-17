class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.46.0.tar.gz"
  sha256 "3ff055722479be90ce0ad240898162e257bc284af5d20e70d490d68a54828fa9"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e18f98affd307c33d4c17fc0f2ab0f44d2642b69526075fc67cc6cd4b7173a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "131fdfe0265eb5214f51340fef7b11d324256690d90ae49b31061ff053b6d758"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b69c21dcb5e2838cb0b4d573bc61c33ed4c051886f8fac994843e4a1e601178f"
    sha256 cellar: :any_skip_relocation, sonoma:        "001fa88550125c26312eda08ea162220b896b8ca0ab4355b808888f7ff50f99a"
    sha256 cellar: :any_skip_relocation, ventura:       "d8e7f745e56c567f13c80e47c8accfc6820c963bb666e3c26868e3d873f36c7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e0d23956f86328e3237fa0aaf95339204ed18bc270c8509e29a7e37e9ddb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe349349d859efcae8f275a3268cdd399e437610e168839f9744afc572eef06"
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
      w.write "n\r\n"
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