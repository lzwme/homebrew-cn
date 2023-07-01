class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://ghproxy.com/https://github.com/rclone/rclone/archive/v1.63.0.tar.gz"
  sha256 "755af528052f946e8d41a3e96e5dbf8f03ecfe398f9d0fdeb7ca1a59208a75db"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "601e7b18381bde4bc7a462c6ffbe86a6da0fcba21265a46c94eaa2937b0c205d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4ff9ff7791212d97b300af3aa9f050133717a925ec43217b2b29472f364126"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16726ff2ee0bce328c652ea56f9e6477cf7e2e6e6ecfbfe3e54ca63ebf2424e1"
    sha256 cellar: :any_skip_relocation, ventura:        "e6a39a95b75ce663abc6637e3c177adb5c33b20edcb0c81d1798e56b690bc951"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd3843c05db56b9628cdd0bef6fcf52e0657cd5f2e724c31c6b8f7f6a3910db"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf1b302cd938bd1bbd4c9448123621e18fcea4d3f077d195d2838f39759de8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e441c7296de2fd80faa4747c4efd145df5c23ee5eb02c49c9f04e72e67ca96f0"
  end

  depends_on "go" => :build

  # Fix builds on macOS < 12.
  patch do
    url "https://github.com/rclone/rclone/commit/c5a6821a8f09b1ac88e246a775d99271fa12cecd.patch?full_index=1"
    sha256 "ca7fdb4200fc4e2919c99a3d392779ccf65ffe8f10bfde4c965fef8e4984d585"
  end

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