class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://ghfast.top/https://github.com/istio/istio/archive/refs/tags/1.26.3.tar.gz"
  sha256 "38503a436851e01972b811683d5c8ba71cc3b64a2f9e9c80b6e3dbbde5cbdb68"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7fcf63abe6a0b69ea6835418f112445e690c949f9466d0c2a48c1d5fdacd211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00798714a294439836bbca12c4b88c433bb1c2061c56886f5758a5c16804ce2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f05db8dbe21500187bdafc84fea47415e13092930d9e3feb8d73abce37484147"
    sha256 cellar: :any_skip_relocation, sonoma:        "0776b1dc906ec3381f0e8222ebbed3341c605accb8c152d9da9708721772b20b"
    sha256 cellar: :any_skip_relocation, ventura:       "f96651592930c30c09d69fca0b1710acfd292cac38afd34f8d63361bb8d44fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b2156bdd1e6ee0be90280d22c29044318feed243a92ffb6e83adf08a04f35b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d609e27ec1be0cefd425e356c2b0a51376b1bb8e725d28b07a66de3702b52560"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end