class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https:linuxcontainers.orgincus"
  url "https:linuxcontainers.orgdownloadsincusincus-6.5.tar.xz"
  sha256 "d79d76c42c430b0346f25fee1059dbe0ab0db2319faaa6e0eeb6ad3982023662"
  license "Apache-2.0"
  head "https:github.comlxcincus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a25b672915d710e1401aaf84c45656d7aa2c528d14a9319968a9331a3d4d91ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a25b672915d710e1401aaf84c45656d7aa2c528d14a9319968a9331a3d4d91ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a25b672915d710e1401aaf84c45656d7aa2c528d14a9319968a9331a3d4d91ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "5eb315a0c1fe2a6db9598ce6fb1e443d3dbf9b29583971504e8b467966fdfe5e"
    sha256 cellar: :any_skip_relocation, ventura:        "5eb315a0c1fe2a6db9598ce6fb1e443d3dbf9b29583971504e8b467966fdfe5e"
    sha256 cellar: :any_skip_relocation, monterey:       "5eb315a0c1fe2a6db9598ce6fb1e443d3dbf9b29583971504e8b467966fdfe5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2b5df0c67f192ac3206c9459f33bac01f1a0dfef02e1154830556d34e2def0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdincus"

    generate_completions_from_executable(bin"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}incus remote list --format json"))
    assert_equal "https:images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}incus --version")
  end
end