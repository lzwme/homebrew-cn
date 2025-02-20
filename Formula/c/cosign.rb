class Cosign < Formula
  desc "Container Signing"
  homepage "https:github.comsigstorecosign"
  url "https:github.comsigstorecosign.git",
      tag:      "v2.4.3",
      revision: "6a7abbf3ae7eb6949883a80c8f6007cc065d2dfb"
  license "Apache-2.0"
  head "https:github.comsigstorecosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b6136f1eb6d0f0301016ab7650e6d81c85662a9e6a40cbf3efa98d75e24df9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b6136f1eb6d0f0301016ab7650e6d81c85662a9e6a40cbf3efa98d75e24df9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b6136f1eb6d0f0301016ab7650e6d81c85662a9e6a40cbf3efa98d75e24df9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "971ff9c4bff3fc5cd415e7b4af7ca62f61c087ddfe07e8f50b27414fdff00eec"
    sha256 cellar: :any_skip_relocation, ventura:       "f06fec593603209357e51b7ddc519354c8b7fb4afc56d920741b4b83a7d57156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8841e368a9cacd521192289a0c16a97fe472eb09431dc92ea7591780212b6c"
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