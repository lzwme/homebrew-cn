class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.39.2.tar.gz"
  sha256 "8b77573044d032a6df1c051bcbacc044b198fd9b0c64e8f43a34179cbf81167d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32d8bffe5eb155ff5c46d739bec5e8775212160442ab15e98e1f03b343ee543d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a23f6a13f1aff60db79aa379b6fe5799486e020be0bb1711f4ef85e0a45c2364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d26044ea2fd4741c251c2d9ade595d21960a4d175a53f3bd129ad57d3d7ef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a626c7ff6424fef4822a2e3589ec6a61ad981e0a132124f548d371cf3b3759bb"
    sha256 cellar: :any,                 x86_64_linux:  "26148d5ac07c7b877828ff7272488d16a6b8d346719e1ac6a86bb166c2047052"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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