class RekorCli < Formula
  desc "CLI for interacting with Rekor"
  homepage "https://docs.sigstore.dev/logging/overview/"
  url "https://ghproxy.com/https://github.com/sigstore/rekor/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "2e4e75fcae81ef85e6e3c20e00a9b590bfa86c0706a6c902024222cd61b64c47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e9092fd560c12d23cc01b882692d249c0d77bca9fafd00a3d31857d2ca212e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29542b8f977f39f3c7680d827a4df3489810c5f97697c40d5c1dce51ea33ca9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd41e1dbfc5539f559a13b59c33889b128cca9e853188aaaf21b7133b97365b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "49b6c11db4055fdb9318843fd3d3274c0f6b7cf35b0347e31f1b3e9e82f11d04"
    sha256 cellar: :any_skip_relocation, ventura:        "fc61b0c1aba0abd6491beffa1f26e5c2ae54aab100e786dffc343d13c6cf9694"
    sha256 cellar: :any_skip_relocation, monterey:       "d0392124e8e477033933ac3027e702784c1fd366d0296c5cff30794e1670d089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b909afeff48519491095e9420c506b5ceca1d8667f96b1980b794427d5dedb"
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