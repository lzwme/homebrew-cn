class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.28.0",
      revision: "a9696201f760013182c6cdba7c4ed3c236a6423b"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ecf5cdc35416594de656fbbbc23bd7f9f3d4412915084fafe9022311cf654cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b38bbc16f08d9010097b9b564997cfe5518097e836b4435b84519a11a0a41f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65443490367afe7aa543cda41a164c13d0f80ddf52f778c088e2829d0983190"
    sha256 cellar: :any_skip_relocation, sonoma:        "8454f4756064ba41e819d237cdff2bcf9347122181d6f13e001e3e775eb5dc04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1218c05e5919f6a3725f0a652a81b7627799d36c8749ab6f44e82fb6fbc76f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b77d43ec7e979d0c802000de5c2165b9035d8f7f8bf6c99d5f2a3d65aa42c7e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildVersion=#{version}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildCommit=#{Utils.git_head}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubectl-cnpg"
    generate_completions_from_executable(bin/"kubectl-cnpg", "completion")

    kubectl_plugin_completion = <<~EOS
      #!/usr/bin/env sh
      # Call the __complete command passing it all arguments
      kubectl cnpg __complete "$@"
    EOS

    (bin/"kubectl_complete-cnpg").write(kubectl_plugin_completion)
    chmod 0755, bin/"kubectl_complete-cnpg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-cnpg version")
    assert_match "connect: connection refused", shell_output("#{bin}/kubectl-cnpg status dummy-cluster 2>&1", 1)
  end
end