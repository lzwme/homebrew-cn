class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://ghproxy.com/https://github.com/rclone/rclone/archive/v1.64.2.tar.gz"
  sha256 "85feffc2d60554bcc3c59140750dc4ccf008e109b52c451956a1f52387af1bd6"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4afe9d2f7486a3dddba567553bb03225b4fb190cff7e3f746ff3017b0cc4c31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8c2403d41ff5403491f22da9293cc57e8a3053105d9822ed418a5db41e80088"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22b3103ac7971e23e1b6b408e554fccc5ebc878d439b047be07e17142419cea4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b2c368073e7ce78737f25febd9006bcc232d07e768b96c24775e87c5422e55d"
    sha256 cellar: :any_skip_relocation, ventura:        "899aa8fe00ccb9ed1acf2eb8948b9698847159b086c727f6f9a3b0cf3513936c"
    sha256 cellar: :any_skip_relocation, monterey:       "e5d950991458913aa1ddc78faf25f4f52f5065248a385c62c65dda9d463d52d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8d2b8e0c5760f8567190e2db6862fe18fc2b71e8f94482e79a26ec1b60df0d"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w -X github.com/rclone/rclone/fs.Version=v#{version}")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args
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
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end