class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/2.14.1.tar.gz"
  sha256 "05a002cf1122f83b75f5acd6e1fcf5f4e15c9524a6904650905777d3e871a150"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "313a096e8c17c73f892adcb3060ffb8c082ef590a94dd10238519ac58a3d54a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9090fa8574cbded40adb285718aa5a4a190d5cbd80deaee506c2b774fcabf75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "309b3605e09e3600131076f3ee9979c7bfbc039fd5943dde4b413408c5b2f185"
    sha256 cellar: :any_skip_relocation, ventura:        "891a1cd953131d58e03823015606bdcc72b2e5721f82c01bca671faf9a6090b1"
    sha256 cellar: :any_skip_relocation, monterey:       "740d41c17a06c43a91680afb63cfd305a49ec00ebbbd90ea52ac712a8bed3575"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc4d58a6ff57cda8a96079a2c87f46c0237d4947ce9578ca02cd878ea67c9fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4cee4b22b0797ecdfa9e97f007f3c1a5b0237bfa883c90514738e5ede27bb79"
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
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end