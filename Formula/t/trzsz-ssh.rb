class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://ghproxy.com/https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "1b3269bbc5324be6434c07f6b5a8b45b1af5c6f983f0dbc84492a6e5c8fb2a86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a43c018e733f2c31aa865f0371e3fe5731f3e15962de8fc672aff10b1ebcc124"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ae4d309153cbccb484a7812d81a3775d09f882eab0d029833a8c40b80a6c662"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7a9d02b4a5520b6543df5f892e7cc04d6b666d7481e5ef69377b5da5125d20"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e74f5f3379874ade2a46037fb781b32659e1cef08091b0d66ce8bbe8a65a56d"
    sha256 cellar: :any_skip_relocation, ventura:        "1b149873e2796cb8992a31709c6803c97346685e909809ccc474255e1097835d"
    sha256 cellar: :any_skip_relocation, monterey:       "b0b189372de0f4043df033f25a8108b2d505908eda93c920a6ae55dd628a2a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc2f970fc9c175728dd76be9b6e8584935831aed69d078eb68a0776d17953c93"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh -V")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh --version")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc", 255)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz", 255)
    assert_match "invalid forward specification", shell_output("#{bin}/tssh -L 123", 255)
  end
end