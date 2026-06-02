class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://ghfast.top/https://github.com/amitsaha/gitbackup/archive/refs/tags/v1.2.tar.gz"
  sha256 "13fe5e972897c9cd2548c569794088392c8e6a0296db10aa2c400cfeacd29e2a"
  license "MIT"
  head "https://github.com/amitsaha/gitbackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb10abf44464ba6b631a1942d065ad56352b4602997b80f325a7db4b631f5abf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb10abf44464ba6b631a1942d065ad56352b4602997b80f325a7db4b631f5abf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb10abf44464ba6b631a1942d065ad56352b4602997b80f325a7db4b631f5abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8a848fe6a468af28955fe184b6a7502262879da543bf5f4ddfd7d673bd03983"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f20625c64ba452fa63277ae6b82b16b97865bb95ac719804724eb183063cdad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c95297580dd486bed87e128a8bb08a71198fe83ab6bf9d7bf41d5c4ab71e8612"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end