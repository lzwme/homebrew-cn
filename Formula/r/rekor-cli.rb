class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://ghproxy.com/https://github.com/sigstore/rekor/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "22e6006a26fe2e6f4ec6b16be1198eabbb957221a7f92f3ef8636cbd7686479e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e6f4100b488cd2d07a21b8a424a7a0e91bf866b48e401865a8c051c0d5be903"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2655402d753e4d9f63f553b4d4349e094643a7dbd1f41cb9b0c5d2c4f421892"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "599f38c48ad27cabd9c11b16c11522480161ca1b91e1c6238ac9e59c7bc3bc70"
    sha256 cellar: :any_skip_relocation, sonoma:         "411edba4a4ae5a21e39117ab02bb48e135ead6db4fa69e11d98b7700468afe11"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9beb3621800623d9bb2a8f69add80cfeef616b22eaa95966895207b9bb5e35"
    sha256 cellar: :any_skip_relocation, monterey:       "bd9c9a9449bf820f29c2102b0ae906188c43824465b89c0b465ddc17a03e7ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa6d8d67e776205b17a70a007633d51f1f3e87abe3301b57a5efc9f0ffd9c85a"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/rekor-cli"

    generate_completions_from_executable(bin/"rekor-cli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rekor-cli version")

    url = "https://ghproxy.com/https://github.com/sigstore/rekor/releases/download/v#{version}/rekor-cli-darwin-arm64"
    output = shell_output("#{bin}/rekor-cli search --artifact #{url} 2>&1")
    assert_match "Found matching entries (listed by UUID):", output
  end
end