class Cosign < Formula
  desc "Container Signing"
  homepage "https:github.comsigstorecosign"
  url "https:github.comsigstorecosign.git",
      tag:      "v2.5.1",
      revision: "a7345fb2ce17b52b5bc687970fa31ff85bc2f7ca"
  license "Apache-2.0"
  head "https:github.comsigstorecosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e4adfdabc941c9c20e20256d84325a61cdecf387f69dd48f8328c555ec6fc61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b807b6842121394815ed5fd3cc03012eaaa8383dbc89b72b7fa38e0975485ff0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "822bf31d57298c019c1828ebfc30b70716621b4c46622709f18a1e8c3f6de1e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b68c40ad0049fa91f0f7071f55c49e01b06cad1b1cf0371634509e73f18c1a37"
    sha256 cellar: :any_skip_relocation, ventura:       "493ec944fde8f191b0880b6e74698068e0f37f58c6dfb4970a780fd7b05f48d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9fb2c71861a4f2f10ef1d4494eec27ce508e0de9e17ed77e240147234cd0505"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.iorelease-utilsversion"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdcosign"

    generate_completions_from_executable(bin"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath"cosign.pub"

    assert_match version.to_s, shell_output(bin"cosign version 2>&1")
  end
end