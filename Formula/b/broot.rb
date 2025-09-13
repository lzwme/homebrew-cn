class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghfast.top/https://github.com/Canop/broot/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "7b8e456c3cdfce87e902b3fa839126e5446ce0f0dbfa9b10db5c2758c1f506b1"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96da1d766212e39712d90e37f59f1e5b567336f9f48a52ee99d9445fb67694c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5bdb741474236097299c784cfc3bee41851d601f509346e945061b031401691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e1148e5279cda7679955f843a9eb14aed51987f4e4ae5e3bc108ccd2c032725"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b3d49de5d31a8152e34476ccc5ff30187e23872cd85e3e07f2a5be733992b27"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e993f4fd0df93d6299c1a66a342ca7ccfed434069cd33a373498eef01d35bf"
    sha256 cellar: :any_skip_relocation, ventura:       "28ae4aca92a061719f4a0bdd03564d8207c0883f347b8739718a798645e2f74e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db4cad182927aac397846364c2de97cfef081f665574010dae0af750d920fc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d297ecc02335c141b034840ee5d79d15c0f7a3a8191b2ca3cdf3968020f6d2e6"
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