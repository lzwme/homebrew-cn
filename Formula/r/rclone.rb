class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https:rclone.org"
  url "https:github.comrclonerclonearchiverefstagsv1.65.0.tar.gz"
  sha256 "22a15cbc381bab351c0698c83c1666344a07e1bde39ba44f33b95c5fb22cfaf4"
  license "MIT"
  head "https:github.comrclonerclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bea146cb528713b7688f5df43691ae1ec750160c5fe3c67b2433c28057ecfeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26d9e0a8ced71699ac144f22ecdae16ce813f5efdfaf7965f5fef52c0ede161c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b9723d1645b687ad4320bdc6c2f4e45d2e8d2fea9961788be09de64a3c71ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "869bbb672ece76f107ea68cb18871daa7604662279f1961d8cb068b56fdb4981"
    sha256 cellar: :any_skip_relocation, ventura:        "8006137800bfe66417a9ea3b798f0cd0febc2ca58754e9c64e9e3d38f10ad98d"
    sha256 cellar: :any_skip_relocation, monterey:       "2d1231b6eb0a36f706e396d5f2dd80626465dea4b54764bba3e5f283581e0468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062e5765989a33c75df27f0af31be9001c1ce536b1c4783bc31ae698305c7a87"
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