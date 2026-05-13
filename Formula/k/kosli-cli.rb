class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "67c96c893deeae95816ccdbe1b347c3e8786413b70c4f09c5a3539eff850acc6"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "028192598a24df0027ce2dd5b3c5ac6311d00bbf075edc4a3af17c0410a1b7dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de97a09749d01141b189fa7c9efa3309a389698a9ddb749f15298913511431b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe1d11dd9b89a447963ded73c641b9e65f5536f26d20425e126f780c5b275d6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f290f6596f6c8cd5ede289064eaa161144cc5d6cb45e4a7a4f657fd2840e9f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b884ac087eb5d6ec2176bc584bd2c58ad50948a931cc6f2aefa1d964791e5813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a438618e75c49b04e495a5b8e3787377673403129db8b842a5e9e41baaaecb49"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end