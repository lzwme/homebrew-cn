class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://ghproxy.com/https://github.com/Canop/broot/archive/v1.26.0.tar.gz"
  sha256 "124c568cec42d4a3ed8550a4f956751f165c72a896df5386045b22518e7ff607"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8adb7b6eee642e52f4ae3cab1e6208d08bf6870c23a1a043f32ad4c0ae92e32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "259a61b19efd91f5f73939b96767bc6c6acd322045aae307675be5cdec110978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc3e76759c735f6a808d6fe5fbea44d5e5fbc191f883948b020e229ffdc426ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "645ee9a0efd80c055b78689cc9962add3087ab8892de0389240cf06c9999863e"
    sha256 cellar: :any_skip_relocation, ventura:        "031c7a264461461d9426887231404156b9d65edda171a9cdeddddbf93f7e88ad"
    sha256 cellar: :any_skip_relocation, monterey:       "1740f005c3883fb8d5416d806b6babc7c905c25115199f08c1ad935f79a9e508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73bb0ed7ca4472f3d75cb4c7bd982d6b89e856bbc3a9d2c58860e2a7cf69797a"
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
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end