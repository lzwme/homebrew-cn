class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https:rclone.org"
  url "https:github.comrclonerclonearchiverefstagsv1.70.2.tar.gz"
  sha256 "dc6b1eabbe35cfde3b9db2a25567ed6d4f4e65b5c71e52da7d6ff5f987ba86dc"
  license "MIT"
  head "https:github.comrclonerclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "953b208565bf218cbddf3a06e6f511d1d6d22aa6ab147b9ff13d0173fa25254d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a32c07210f7fffec38658e07a1d3ab1eaab33a00b59ab32b6846d3700f22bf98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ed7e672426185ea7ee4c689bebdcfd087bc30f2397717f7dad96fc1f847b1c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ce8e8a37fc8c3d61655d55b65cbaa05cd6909759f7afbe059495d5b46518884"
    sha256 cellar: :any_skip_relocation, ventura:       "40c516264de9a923e812ce48ed50ff6b461ff65e9c377d1a5e94c26e0df54acb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01f6465bc4c6294d8f14bd1e0a2fa880a70d4fe5d5faac084f95aba675835607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65017720889ba1f9d1689b017923e24506bf3013e1d794a65e449d23e8ccd1c2"
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