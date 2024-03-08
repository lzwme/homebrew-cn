class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https:kubevela.io"
  url "https:github.comkubevelakubevela.git",
      tag:      "v1.9.9",
      revision: "42d75e09e548be459ba6d53ebc97d931c990edae"
  license "Apache-2.0"
  head "https:github.comkubevelakubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4418e5eb8297874bcd606aa0fb0606194685c4c7ebaa1b927e5be21be02bb2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4418e5eb8297874bcd606aa0fb0606194685c4c7ebaa1b927e5be21be02bb2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4418e5eb8297874bcd606aa0fb0606194685c4c7ebaa1b927e5be21be02bb2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "03516403330ff7acf3123ff385e0e0f4418b1a3682c2e3340951879dca18b12c"
    sha256 cellar: :any_skip_relocation, ventura:        "03516403330ff7acf3123ff385e0e0f4418b1a3682c2e3340951879dca18b12c"
    sha256 cellar: :any_skip_relocation, monterey:       "03516403330ff7acf3123ff385e0e0f4418b1a3682c2e3340951879dca18b12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17348657121bf45b3c3eda3ca80eaf39eff72b539ae25d112175cb6398b5e7eb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.comoam-devkubevelaversion.VelaVersion=#{version}
      -X github.comoam-devkubevelaversion.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin"vela", ldflags:), ".referencescmdcli"

    generate_completions_from_executable(bin"vela", "completion", shells: [:bash, :zsh], base_name: "vela")
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

    (testpath"kube-config").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http:127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    EOS

    ENV["KUBECONFIG"] = testpath"kube-config"
    version_output = shell_output("#{bin}vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end