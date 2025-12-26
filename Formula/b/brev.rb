class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://ghfast.top/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.315.tar.gz"
  sha256 "5bb2e40d4dd80d368c2c0dcc1b2520eeccc530555381b578ed73270ddc4ec180"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ba27dc84997071d831b399765c7056c03b719b8c120881d0c0f00fe16a992d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ba27dc84997071d831b399765c7056c03b719b8c120881d0c0f00fe16a992d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba27dc84997071d831b399765c7056c03b719b8c120881d0c0f00fe16a992d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "474c041572726cb87ed4bbc7833673a1d1a521481485e5196c1634bed5d31179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d2aa0576db70b5dedff9f028969eab46e38561569fdd0750013e0790fda06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3925b8151c2003e0971a59bc72a607603c848861ac34b7f3fabc5365bd1f74c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end