class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghfast.top/https://github.com/Canop/broot/archive/refs/tags/v1.56.3.tar.gz"
  sha256 "48f7fdc6e68539a951207d892916824bb08e8752d2c6aa414ef994f08b6ba43c"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ad08923a83d6a0b4aef44580d972f407a742c474813c2ecbfc602f8e7f29bf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c40e4fe9746dd6f39fc2fdcbfc8714e3576e3aea660f19ed4a78d3761d6e6a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3289a5ba9e73b4eeecfa586416908373c43c3b3267ab63e244e09c2b06c449c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ff1e2cf82c197cfee266058aa6f1c385a23368cef0add41361ceb1ff40e307a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cb9c3bbbbc1973b883b1ea68f19fccd72996742922e3a8cba2af7a37e212370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93b4af00564fe30cc50fa62f96feafe6f390f0f3a1d763f8d843176b15709c9"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    pwsh_completion.install "#{out_dir}/_broot.ps1"
    pwsh_completion.install "#{out_dir}/_br.ps1"
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