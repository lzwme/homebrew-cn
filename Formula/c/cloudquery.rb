class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.35.1.tar.gz"
  sha256 "8c7c0d44ae30bbadcee3e806b8985419f1d40da7eecc4c7698240f28ddd32684"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "976ab7543b66287cd7457f15d83d68add34175e80bc7e7d32a936f104bdce249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "976ab7543b66287cd7457f15d83d68add34175e80bc7e7d32a936f104bdce249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "976ab7543b66287cd7457f15d83d68add34175e80bc7e7d32a936f104bdce249"
    sha256 cellar: :any_skip_relocation, sonoma:        "73264ca246d49ae8cbfa15807ae2e314db4b722812a22bffe9f28e0484b72f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1eb583124aebd99d6f5f57b0828ff52a0278f4fe68cf4b6d661a618507f6115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a39dafa67c917329bf993a45616bc015c0e924598d84fbf4a0dc0f2f964ec41c"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end