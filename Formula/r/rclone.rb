class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https:rclone.org"
  url "https:github.comrclonerclonearchiverefstagsv1.68.2.tar.gz"
  sha256 "6c4c1a1702633c7a8f8755a9cfb951c3ae0b7bcc2e210b92e191250b6aae2e9f"
  license "MIT"
  head "https:github.comrclonerclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e204ccf9aec7bfd64af09c4a6868f0606110455e795d6223d873883d8446008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2195cdc5687b73c927d179eec4401f132d551dafde5ae8535bcdd101840fc3d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85dbce18c21843d6e17c526c6b0a0b2d46ddc47b10911069b140640976c396ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "97af4aad9c2fdaa3da04d6068870ee3152834c2bf3cdc2ac9dce1da88a1b3382"
    sha256 cellar: :any_skip_relocation, ventura:       "11ae93e0fc603ee10e2a442bf320be22150bb789cf4756db9338c43a277040f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "933e9ffc6c153cd1ec2d38b8d5c2ace178b493ca46e83914af1bcc4fe5d13595"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w -X github.comrclonerclonefs.Version=v#{version}")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args
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