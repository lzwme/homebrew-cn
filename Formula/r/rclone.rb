class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://ghfast.top/https://github.com/rclone/rclone/archive/refs/tags/v1.73.3.tar.gz"
  sha256 "91a2189140b90b40cf113f974f6441f22b3a21434b00f85cd2dfdc56e6eab3d6"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e8500862a13ec44250664b6880cef834178700a2f4dd626845bd2946edcd798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23f1df224121b23096c456dbd5d0f6eec8a8a83ec239ada0d9f5b470f7e8bb7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fb3f515f952ba5b5821542e9b72f2363b90813cdd46bec321f1a92dbca5f10c"
    sha256 cellar: :any_skip_relocation, sonoma:        "40e9c618e024acd52d3bdb1b217554c8681b336461a8012ee9fdc7c9cc40b6af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9bc0bf4ef4e75e6d94c30b8cdce1f89e63ef5640121469aea73448b1ad8ab7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5c97fcb54e9d8f240e1e588c65901b2a122e04f8066e00c1d500b8cfb7494d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rclone/rclone/fs.Version=v#{version}
    ]
    tags = "brew" if OS.mac?
    system "go", "build", *std_go_args(ldflags:, tags:)
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    system bin/"rclone", "genautocomplete", "fish", "rclone.fish"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
    fish_completion.install "rclone.fish"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end