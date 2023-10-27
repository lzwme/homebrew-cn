class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/refs/tags/2.19.2.tar.gz"
  sha256 "93f10add4cd4aae2ba41b5cf44735d235f258d3e90178550a78c9d80babec9c3"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb037de72583d2b7db858d341ce6f382557578de49e317eb0634f1beb9ee8575"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c84a8858ff33bfdb7def416dcd113330d1d287826103d210d07f581978cabd53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4462c7561a3601a8229849e46bd11e04f1eab3e2bc63a4fde34ae95e736e1891"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc13b323008135092a1302edc292ea3ec0a77d36c7857d1e59ee677450694ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "b3199199d255f0b196157f87a2729adb2d5b47e34c4222696000d7c06f52c845"
    sha256 cellar: :any_skip_relocation, monterey:       "e435e3d51d939a626f133fa382afeea3af2e7795d5d99a46329fa30e25fe1d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb1fa4ca75688b9df0249ba8f21a001113d6c184d8b1477c4bf67d150a2175b"
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