class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.46.4.tar.gz"
  sha256 "d0080fb6f959ca8978b3930513f72df7a6ef6bc9c204ff499458961c5671c67b"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d8324d2661d6c3791e69333b4ca5f618d7f72c7e2d3d2723f68a4a5097a0665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee27a0462ca030af2e2a8940e72d221eded464ee4d993a5b9bbcb5b35c6911e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "750006211ada3176625e538cca4b92f2aa74caad64a6b990ce9db3343cb29873"
    sha256 cellar: :any_skip_relocation, sonoma:        "13735bdfac1c9db94b50f610096ee53a1e2048671fba8f18f6483447be0c2159"
    sha256 cellar: :any_skip_relocation, ventura:       "16f07c0b4136a8ad52d4fd470c3f7e06a32f69a6266490d69466724c26233651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66b73baa6992bc8f5561836a930300e89b48acd7410b3879b61bdfb1181a2574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6feeaa0dee66af7c6e0b00dda4e5b808a7ee9354c86c565ce0f2537029fb5711"
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