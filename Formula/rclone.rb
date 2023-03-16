class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://ghproxy.com/https://github.com/rclone/rclone/archive/v1.62.1.tar.gz"
  sha256 "ce3b51edda9d0a476d9abc276ac6a374c7d6ba8be22caa8e33845797e6fc4f98"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eb5284043d102c818f0e90885549db3faea5a298fd6de418b11a01d5ffd586e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c317c3786d2b1de1741d88f9a45029925bfe829ab67d7373b39f73daaa6cb94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d287f4a5f4081237fb641b226a44efbe8d57a0b8c305f9189e9575808c073e97"
    sha256 cellar: :any_skip_relocation, ventura:        "ddd0a8b88e487ec83e5f13823980150eb9435374f410691afb67d8569f946484"
    sha256 cellar: :any_skip_relocation, monterey:       "69b3ef403bfabc58908eabd5d5c5b18c92a6dc67dec818d0247416475e5fa663"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0ce2143634506c14721c24069f57b231d8d0b660ded87ec2f92597d133b5a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cafa57fe7d5a362e42fdd86a143132a0c99fc1d3e2abf25b366f5e3530c57179"
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