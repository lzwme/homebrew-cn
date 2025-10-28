class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "fb954ad248d7dd4a58abebc0339f2d5536b2f4851241de4a6625f58e26231d2e"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "585ed70252d49bf2bfa6e0c98d7325751e0f47749ed4ee0ec65aecbc2f870f9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "585ed70252d49bf2bfa6e0c98d7325751e0f47749ed4ee0ec65aecbc2f870f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "585ed70252d49bf2bfa6e0c98d7325751e0f47749ed4ee0ec65aecbc2f870f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b733a3af8f68e68176ce7162a7c4c65a9a378ecd03ebbafad22ab3b252f741ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6489b2fb3b8e7392ef2043191d69ada63fbd9d485995959324c83aa94805af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a29fef04b14fbe7205a42f45ed1807d73c6a9ec45c176e7b907059d258fcc764"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end