class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://ghfast.top/https://github.com/sigstore/rekor/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "28a2fb9e4b97057b06c9c226534d27510c47445d2622dd2556b9f90903c2f8f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1947724858e53b73f7f1bb8f39f1503bcb86e90d331b7e354fc39aa92f03c78a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1947724858e53b73f7f1bb8f39f1503bcb86e90d331b7e354fc39aa92f03c78a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1947724858e53b73f7f1bb8f39f1503bcb86e90d331b7e354fc39aa92f03c78a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe3973cc5c656b79396993f7c62e1769da593e5d6c7ab6646c0a122480c8fcf"
    sha256 cellar: :any_skip_relocation, ventura:       "bbe3973cc5c656b79396993f7c62e1769da593e5d6c7ab6646c0a122480c8fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6a856cb2aa7fa6156a7b1aecf27a9435f4c63dc01e63c9f3a431b1c6016a7e"
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