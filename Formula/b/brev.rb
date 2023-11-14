class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.266.tar.gz"
  sha256 "3d12e7e2c308d1ffe82115931547924004751ee318ec5bc4e4705fa96195f91e"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2421b2dca1ab526378f94ae77595aaf1adb18ff66177b79a13b684738455cf5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb22314cf7ec1cfec3764432af5982f7edcb192a74b3d6ed8aa30787cab884e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45a972d21a68c629cfa62b3c6fb25cf375b70fbb046f3a274b68dfb2a84e029a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9fb60d081968d72eee2151cc871c3d78fc8e9ae36828fb15048845e16e99ede"
    sha256 cellar: :any_skip_relocation, ventura:        "2706ed6d1e37b396f901dfed6764321522f551ef909db706b0f6c29687d71385"
    sha256 cellar: :any_skip_relocation, monterey:       "78b3d784b58704d6e0993ca6fa93483d1c71337d3bb60b498d2fce1fbb3a4ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66240e2bd70c0a1995d277cdcf947d29731de540add05562448edcbebfb0e2c7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end