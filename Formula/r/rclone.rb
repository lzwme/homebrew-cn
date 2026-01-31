class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://ghfast.top/https://github.com/rclone/rclone/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "91c777ce0bf41caa5de9aeaeae37310f9310bd7b12b5eee7337f57cbaae5830c"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6a1ec94e5f5c4c12b3b35eb85ddf39f80214063a932f24cd3dc7b6af7feefc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940ecc5f8b7b71edbdf7e0160a5fd368d88470c6b1cf64ec3c56d359c6a81744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5feb8fc5e6ea3256b759be7e64a1f117e9fa3dc46d87a6657462c6ee7b85d97e"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c6b386c466932ba813a0b9c6a42a609a88c805de4927f7854e6e9006f9e83b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31b928cc7ea70fe040dc1045dcfb504267fbaf28756e8ed96375f34566e179da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "950572c8999baa924b088836d2bbb68a719147e7c7d6061ec8271a2bd981b68c"
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