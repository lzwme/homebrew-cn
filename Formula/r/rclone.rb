class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https:rclone.org"
  url "https:github.comrclonerclonearchiverefstagsv1.68.0.tar.gz"
  sha256 "6e0acbef1c9d21d7a4d53d876c374466de0966f2a1994a8ae448ea0c179ccc6a"
  license "MIT"
  head "https:github.comrclonerclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9ddd7c0a9d77cd1b913c7b21cac46472e9d6ca41ec39357c166b5ba081d51355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b11ac9e82d07d7afb1a49411d448f1a760a003e37fea2698c4436a90168676b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd82f190966aaa8b95a7d9e3e98c9177fc6ab1156dbdc6a20c96349703c53108"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "314f81b6f23deb229571b5cfccd74460ab173a1feed3eec33f8de819b930b1e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4680f297f389c4b18067ba5267f216ff28f7cc24ed850757e160f2a131d4361a"
    sha256 cellar: :any_skip_relocation, ventura:        "796a0548ca8c5c235ba0f95dfa7abebb6593bc55f4af698a16b6a21c823196fd"
    sha256 cellar: :any_skip_relocation, monterey:       "c099998184d9fa6fc9a7d4d24a951a7e71ced6d980a459884d7c57d9a148de62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "113f3f09231f9ce6dc4ab90a3bb4ac098422620f367f9e67f780f8a135c9e149"
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