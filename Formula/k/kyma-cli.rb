class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/refs/tags/2.20.0.tar.gz"
  sha256 "5ed969498f7f642ae8ce57fd25185a87775fb45494164058d4478ff769ca8505"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cc638df3b7008776bc77a4dc6b46e368697be922af77195c2601d066cfae2f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11abd267e73b20c662804416a3707948e1a1b6f979d3d91f31bc6df1ceba460f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ce50019bbd8b3099fd94ef6c97a524c0fcc5c0328a48ad0a74d35f4d4af8186"
    sha256 cellar: :any_skip_relocation, sonoma:         "971c12b21a51520b895ff468760cdf0431a39bb53e520ecc7bde02f01e79c066"
    sha256 cellar: :any_skip_relocation, ventura:        "0fddec4713b0d58f79a0d5b947153db011b8726604712446d32fa3235d5427d9"
    sha256 cellar: :any_skip_relocation, monterey:       "f58d044c3afe11a8743230d67328d53e771f77442ba1d7ae28d3c5f37a015ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f823cf5dd202c9564e9613f8824a17904831890c034824f27282608a2f10559"
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