class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https:rclone.org"
  url "https:github.comrclonerclonearchiverefstagsv1.70.0.tar.gz"
  sha256 "7f258d7d3150f419dbccc22152198e8cf179c272c4e15726575343579bddf580"
  license "MIT"
  head "https:github.comrclonerclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98aa2f624411711b0ffca589714e3f3a929d86b0c8ccc2747b329b5ef8c2fd62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a2238e1ee5ff039cf1ff65ebe5d0f14e72ce482dc4f2fb13ca9e17e77e74157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "309522e3eebc704a7b3e81f143196cb30f99d30f93914f82f4f35acf70cc23bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fd9b9e1230724f44a212b0486e7c007d59004935f382165ee3cb0628e530274"
    sha256 cellar: :any_skip_relocation, ventura:       "937e8a685bd7f7409c0de13e5ab0650aecf61544d55d6ec8d3d4faa96fdaf011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4219450b419be05d2ac998a421d070049f93976adce88b0d509b8ee575c3243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64f02ecfc7355fd5bca2ab45f86c94ee5bf6e684a0db50a7eadf243836af40a4"
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