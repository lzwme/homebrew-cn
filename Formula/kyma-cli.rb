class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/2.14.0.tar.gz"
  sha256 "ff9990848eb066ce8cc2b83522edcc08e01a3ebb1404126af56048d26947376a"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "448eb51052b99a97aacae742f86611313c21b30e7049f1f5cb54c77e92085f0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d157e1fe1f32d32647ba132d80879c46bbf7e3b73443cb308fc3208ea91a1fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1b5cae82e9bd3dfd13e435529500ee78ebf0adb8e1679f443e39eda00c7c219"
    sha256 cellar: :any_skip_relocation, ventura:        "b69fc5daa2026bc39a62c4c04e0a5d99e52f8f8dadbd8200b15a46822439b2df"
    sha256 cellar: :any_skip_relocation, monterey:       "4901abcbb8c8d71cfdacd55946ee99d7215979746204e222870437883944fd87"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea8e24d2564b74f40ae6f70398fd1d8b3fccbc7a9b1fbc689474cd12fafed696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "839713e5b7196cc89a745e681b9d5fbe3863890cbb4da6831dc5ab9c46dab0b1"
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