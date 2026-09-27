class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghfast.top/https://github.com/Canop/broot/archive/refs/tags/v1.60.2.tar.gz"
  sha256 "b68f641c4570e2d7bbf90613e67f9cfddf0df42da993913ddc83e7d8a4e5eae6"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ff35f7d4372d9e5bcc30ae6733b7c1f714ce782b344230c0d0459904a33e78d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "082ad860193008e037476f10c2c6f2d1a1358f84c41d025c158439f87d897354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a8da6583e915bb9b02bc19795a5b2b653ca25ea5d3df0dc94ab8db82c316adb"
    sha256 cellar: :any,                 arm64_linux:       "07709d458d2fff76fd5ab3d21df7ac338aba3b1010630b8b5abbe5e8a76f4202"
    sha256 cellar: :any,                 x86_64_linux:      "f0491d3ceb19916349bcc1bd9f420fd36d80ad4fcbf32731566350922fd0eddf"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    (testpath/"conf.hjson").write "enable_kitty_keyboard: false\n"
    (testpath/"test.txt").write "Homebrew\n"

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--conf", testpath/"conf.hjson", "-c", ":print_tree", "--color", "no") do |r, _w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "test.txt", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end