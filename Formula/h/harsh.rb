class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "3c8fcc98b9f0d7c06bd3496868a559d6f833dd63734a988ed2c3045c7348a654"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bfdffd45afeac82bd212890bd1c9a53e0bf1ccd59ba23066cf27c9d79d9ded9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bfdffd45afeac82bd212890bd1c9a53e0bf1ccd59ba23066cf27c9d79d9ded9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bfdffd45afeac82bd212890bd1c9a53e0bf1ccd59ba23066cf27c9d79d9ded9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa751f54c32a76f612dd55b93fc8848cb8f83df17a32899cbfc578d6e649b483"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "109388aacb5ce81a449860ee87601fad03daeed6b730cdac641462bcf6b1859e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f66ec182624b956ad495792d334cb9f4d4abf8e40db87a558fd569ba4782e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end