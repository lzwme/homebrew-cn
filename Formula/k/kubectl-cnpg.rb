class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https:cloudnative-pg.io"
  url "https:github.comcloudnative-pgcloudnative-pg.git",
      tag:      "v1.23.1",
      revision: "336ddf5308fe0d5cf78c4da1d03959fa02a60c70"
  license "Apache-2.0"
  head "https:github.comcloudnative-pgcloudnative-pg.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a0bc1f7c973eee09662a1a1935e95e83dd55129a8f92e9c9eb8a0474feb618a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4c82a28026cadd104395dda232302940b47e05d8bd8419a38ea77f9f6f0b70e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "098baeb0085db072740805d58566b8002fc03f155f9982d4e7a613b35a0f888e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f90320184cc066cae8a42d32695dff1779edc7f2fd0d5c609f7166e3ea01cf4"
    sha256 cellar: :any_skip_relocation, ventura:        "5fa7175b9234d3354305df2e65cc493ee4c5b3e2480fbec68eeba99f1cddc344"
    sha256 cellar: :any_skip_relocation, monterey:       "f7604027cda0bf89ec97e0e0039a19eb7a9e408355ec6a3ea225d054fbb45423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "599802b5d9c2b751573c423e2121aa0f43f09a1f55200f7d69c3e11e67de26cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcloudnative-pgcloudnative-pgpkgversions.buildVersion=#{version}
      -X github.comcloudnative-pgcloudnative-pgpkgversions.buildCommit=#{Utils.git_head}
      -X github.comcloudnative-pgcloudnative-pgpkgversions.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkubectl-cnpg"
    generate_completions_from_executable(bin"kubectl-cnpg", "completion")

    kubectl_plugin_completion = <<~EOS
      #!usrbinenv sh
      # Call the __complete command passing it all arguments
      kubectl cnpg __complete "$@"
    EOS

    (bin"kubectl_complete-cnpg").write(kubectl_plugin_completion)
    chmod 0755, bin"kubectl_complete-cnpg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kubectl-cnpg version")
    assert_match "connect: connection refused", shell_output("#{bin}kubectl-cnpg status dummy-cluster 2>&1", 1)
  end
end