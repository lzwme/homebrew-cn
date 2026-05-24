class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://ghfast.top/https://github.com/rclone/rclone/archive/refs/tags/v1.74.2.tar.gz"
  sha256 "2373a74751cfd2034cc6b792a9a15d119087cb77975f3c9fcd7a4503c15102b0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "248647cfaf59e0e3030acfecc3fe5a4c06a2db2e70a304d74f10b8e6f8c4387d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56dfea1345299b32066c49e4989bb1f2d0e99c167db4de9e8b4924277a79df79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc6b43e01d13c95994c0d5ddfbe5a872d4252bd5204fa9e19227c84123bf00e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3cbe72af7b2c26e70fee1598bc43b1b0439b7f9f0f3802f9d0375efef2a8ce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ff5e514a7689c2ed3553bd83ff0af19b3dcd4a9ed43f2207f55dfc356d9f144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5970a9aa0c035fcf65f3a95791b9a932940aba2988f8b5c11e0242d93f64d7"
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