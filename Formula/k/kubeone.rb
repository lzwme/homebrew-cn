class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://ghfast.top/https://github.com/kubermatic/kubeone/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "5f500a2c7e3073de55498903b077ee0df36bcc0be31eeb25bef1f33ba07b5d27"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb40ad33976f029d6af6f40ba47ca5733081586871433934e8ec2da32d57614d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4883d62ec19e06a03d4e80a4d24f285f851375f23d8ff3c82fdca5ac0cc6447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84277ccda02d17b1ffde7b694cdbd61d3096ae280f9669d23356acf6d8349a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceeab742f2304b592b9589c11572e6de48e1dc31968dbbbded7be2c0e7a19c55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c9cfa14fe22ba2d715d0764841017308caefdf443903d800c873f94fd801c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b302f023b2dfaddc421c1d9a43cd3ae48497a3571995a777a70b7dde0a8efa3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X k8c.io/kubeone/pkg/cmd.version=#{version}
      -X k8c.io/kubeone/pkg/cmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeone", "completion")
  end

  test do
    test_config = testpath/"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.io/v1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}/kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}/kubeone version")
  end
end