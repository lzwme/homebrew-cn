class E1s < Formula
  desc "TUI for managing AWS ECS, inspired by k9s"
  homepage "https://github.com/keidarcy/e1s"
  url "https://ghfast.top/https://github.com/keidarcy/e1s/archive/refs/tags/v1.0.51.tar.gz"
  sha256 "c0f368ca487386b9105b675aff066eb9d1f03a31e1edcd2986bccb687c07058e"
  license "MIT"
  head "https://github.com/keidarcy/e1s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "433ebf2fe184d1973d350cc3af5dbaf2fd881bb66824f75a8af2f0e84799cc10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "433ebf2fe184d1973d350cc3af5dbaf2fd881bb66824f75a8af2f0e84799cc10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "433ebf2fe184d1973d350cc3af5dbaf2fd881bb66824f75a8af2f0e84799cc10"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd1204d8fb9748e1fa1e5fbc4eb02befdb8c2e6c0f72fd0f75b2ae9655e76f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aba9728b9d27885219a5dbc55fc96508f90efca276229641b47989c9e9180c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7f1acef3f4de9c2fee4698f18a55894dd228d2a91135d8ad062554db9593ee8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/e1s"
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match version.to_s, shell_output("#{bin}/e1s --version")

    output = shell_output("#{bin}/e1s --json --region us-east-1 2>&1", 1)
    assert_match "e1s failed to start, please check your aws cli credential and permission", output
  end
end