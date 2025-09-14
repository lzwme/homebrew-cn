class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghfast.top/https://github.com/Canop/broot/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "3e71112876a54c0fef3b2e0f24fd078e283f04613d8de4c6a0bb931a0fdf0e23"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10a13c4dc7e1dc069aa7d73d5b84482479738ea48748045e0aa89fed670b1b23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de634526442638c9cad2700e82528473ba5ac8327bfd2a8df198fc323cffb16c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c96c269aa86a37ede422b1c7aebc7c71b543ef227c45e958eb77ab4e894aa1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a8fbabc3d235b0647c5b6daecc9e2a9eb30dd37e9f157396bff1cde77edd994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28afa61863fe22eefcb3e4123d8d6f751dfe0b0707ffae41051d23f7c962da33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dbcaaf0ae896871437a06ff23979d298a364a7064c3b7d8c4482a2c0c723a3b"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
    bash_completion.install "#{out_dir}/broot.bash" => "broot"
    bash_completion.install "#{out_dir}/br.bash" => "br"
  end

  test do
    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r\n"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "New Configuration files written in", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end