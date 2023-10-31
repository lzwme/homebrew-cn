class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/refs/tags/2.19.3.tar.gz"
  sha256 "ed39a56893d04cababefef22126b781cd49694dd5b8b7d99b7f99ccfb85c9620"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2873da4c3cce876252f2e5780db7191248de647653015b46eb2454a72e19bc50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "989962f668b7594b6a0e32228afbe3badae3863aba407c25e07c1ac64fd5c2ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b0180145aef23a52ab9f9eda00479f32032e38a25e1b8f282a47f9f26724cde"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9d1b708037f42d110a5f4cdb6a241f35c37563c691dc2d707455f8e2e9e20fe"
    sha256 cellar: :any_skip_relocation, ventura:        "b399ad566f64a116a158f09373a2d6e266cbbe509426ac72ba0ea224de683350"
    sha256 cellar: :any_skip_relocation, monterey:       "e9e1eee81431abf914bff08e9de83a9b4b01895d2f990bd93b487933b3bb9fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99de1baa1783d0620d0be1ea936608f2e6d3b86284391bc5b67270b4fe34e12b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end