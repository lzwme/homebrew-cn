class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://ghfast.top/https://github.com/kubermatic/kubeone/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "61c26fadff5b0a5dde348cb6dcef857389ca2c32f621bd7efdace4acf96c88a4"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66fe5ad196567ea5c409d4a8a1186c2f4ca78449e3065a641addde1663d141de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f40171f8d8e910dfae076c168a3d40268b77a56ec83e4529da92896b25aeb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1516de248aad95f062049bf4e069733dab645a94abcf3967afc8bf84621b51ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5427d3a9928da73b3356eaaac83ea19dfeed03d0af6609db739ca5fd497a568"
    sha256 cellar: :any_skip_relocation, ventura:       "ca6c1a9b34be434c178fa55f004351e0f0c2e932860377936fd728dbbc33df13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6b0466d7b295dbac21e7be17bea429afd7b46c0949117470e2f4affb77723d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e266c2564c14385747407e5fd41ca62984a621b962bb94c58f5c2673572554"
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