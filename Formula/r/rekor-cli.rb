class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://ghfast.top/https://github.com/sigstore/rekor/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "41f3f7f9ca9110fb641a0150a9eb82b5b4314b2236ec60fa4644a98220e8341e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b2e3d4989ae902e656c426f196735912ad2dfee1ce31c5924d7cbfaba1c91fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5a9cc8df23774293a651f4602ef1f203e6a1af71df5237fc2f2266e90bcc125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5a9cc8df23774293a651f4602ef1f203e6a1af71df5237fc2f2266e90bcc125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5a9cc8df23774293a651f4602ef1f203e6a1af71df5237fc2f2266e90bcc125"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf2c3ba29bb9f3a886fd5a1a23e2bc79ee218dff6792a98383ca277eea5fb72b"
    sha256 cellar: :any_skip_relocation, ventura:       "cf2c3ba29bb9f3a886fd5a1a23e2bc79ee218dff6792a98383ca277eea5fb72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3450bc24ea59e2dcbfa4b9352502b589efce36863eb03dcd7013ccbc836d9ec1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=#{tap.user}
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/rekor-cli"

    generate_completions_from_executable(bin/"rekor-cli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rekor-cli version")

    url = "https://ghfast.top/https://github.com/sigstore/rekor/releases/download/v#{version}/rekor-cli-darwin-arm64"
    output = shell_output("#{bin}/rekor-cli search --artifact #{url} 2>&1")
    assert_match "Found matching entries (listed by UUID):", output
  end
end