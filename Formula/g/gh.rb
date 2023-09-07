class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://ghproxy.com/https://github.com/cli/cli/archive/v2.34.0.tar.gz"
  sha256 "d872d2e9a934aefce0e9873033fee3aa160a6079af73598b7f8d04c4a3d15a7e"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "531074b34264565f7b1e07a0b4b693ef3b22d1759267bce4864c44207fe2e7a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4870323f399e4b95b7b4ed85272bffc613fe951916be963d488f29bc1d6c47a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96a928ccba903ade85953f86d24fe2bd82aa2e1805dd0215debd0f46d2fbedb4"
    sha256 cellar: :any_skip_relocation, ventura:        "0141e3ae64a039f1089612cf4cffe67f0715e11ddd6213c410e2b972903ebbbd"
    sha256 cellar: :any_skip_relocation, monterey:       "2d52bb74d3194bffc5d1e25490cdb4bd0f52faed671319956bc5bf8ae6d01a3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "73f4913fd763170bc4234b57fe3ab864cf1df4050d5c8167df312311190322e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25cec8475b1474209f5ef34eff231a95d31acc156c165feb771c48009db87f90"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end