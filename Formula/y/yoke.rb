class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.22.3",
      revision: "4dde655d22e9e0537d970835ae6dd4330a35a7d8"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5338d3033d98d054711b56c348f870ee0a2e84211be598a351b2c2ceaba1ce7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59cda4946c5a0e004e379ad57b0c3edb67a06f3fa1f8c59a4cf7cf400e99f086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1c4f97246312a8b0f4dcd2df597432c9719a7f15c83316f6b76b57be9c48443"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "783c6d71cc37303ee45cff15dd57901975aa5dd6ec1d60b680b00979971f4c54"
    sha256 cellar: :any,                 x86_64_linux:      "70e9f88a954d5ef1905342ae4895bdaa4a44b1f6347b3d301840ce50df5d91c4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end