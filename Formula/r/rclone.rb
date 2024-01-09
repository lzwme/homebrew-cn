class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https:rclone.org"
  url "https:github.comrclonerclonearchiverefstagsv1.65.1.tar.gz"
  sha256 "e16f7f6b81865c7f719d4b214ea45a0608ada71d9b9b6f65c6ead21128cbc8fe"
  license "MIT"
  head "https:github.comrclonerclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab7fc762253a0cfb2c2228c91419668e481f796a31079511b3b10e32a96870b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f5ffd2c9f37a8ae4f2550196f8a504e630003867a988f0c1aa1273e9e7f595c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a3166192da42af6530b858044a10c3bbfdc14200cf0a39be79ca52d090e70c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3786d7cd5659a2d497e2914dd7d65645062e76ba860dddf840a725229e92deb8"
    sha256 cellar: :any_skip_relocation, ventura:        "dbc607b564bc586554271ce916d7b1ceca041e5dd783f5449cfe812a4d382f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "486b323a6ab35ee15ff2a0622a8880d23bc39f4dc44b2583c6ee099cc2de9234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b4b8b6d2b5ae60df7c31004cf75352c8ec966b2de7b7fac28a17b7310a96d6"
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