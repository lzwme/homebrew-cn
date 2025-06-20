class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https:rclone.org"
  url "https:github.comrclonerclonearchiverefstagsv1.70.1.tar.gz"
  sha256 "d3d31bdf271a374748b0b1611d82d1a868e87471c31ed9715055b2ae36de7282"
  license "MIT"
  head "https:github.comrclonerclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5c0270d59f9c6f023b9d5996354b0b6d60afe204542f3853ec8de9cf47900b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41bff1bfe78880fc27b564c0a527564de342febc994737d189e31e6909ccadf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dea5e094aa0f6483b6f2885254ba668cad98cf97315d41bd0a93ec26952376ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "837e312010eda7aef323a8079ee0ccdc9ff83f49d7ea8c46ad063f8bdfab7d09"
    sha256 cellar: :any_skip_relocation, ventura:       "8408379762f8abd9c82898fe5b501705c5bab39d15b6fc87ad53838b023dc16c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0854c4431f096cd50e88b0e3bae0fcfc1fb9926195938d2dd444485e7f9bbb37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee949b8f9fadef40764be13a33ace096396d58d02dee1c1dfde145454a2af99"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comrclonerclonefs.Version=v#{version}
    ]
    tags = "brew" if OS.mac?
    system "go", "build", *std_go_args(ldflags:, tags:)
    man1.install "rclone.1"
    system bin"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin"rclone", "genautocomplete", "zsh", "_rclone"
    system bin"rclone", "genautocomplete", "fish", "rclone.fish"
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
    (testpath"file1.txt").write "Test!"
    system bin"rclone", "copy", testpath"file1.txt", testpath"dist"
    assert_match File.read(testpath"file1.txt"), File.read(testpath"distfile1.txt")
  end
end