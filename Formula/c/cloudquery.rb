class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.35.0.tar.gz"
  sha256 "1acdd79605759c5bc42f1852f5095903d855e256428594968833cc2f1c0a1c5c"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e84bafaaea3b47b7b6f6d92e2cf253781470d76df71a2a8ec96d2112ad4a916f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e84bafaaea3b47b7b6f6d92e2cf253781470d76df71a2a8ec96d2112ad4a916f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e84bafaaea3b47b7b6f6d92e2cf253781470d76df71a2a8ec96d2112ad4a916f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d739cc8b187e6325c11429109d179b862d03a569c9ee7d1b1bc846527bf35298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da7fe7ed8424a4a6473b3b6930f96ed7cd8f7553b26bafd624a0d2568f9e3a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95de57603469058ad91e58d71d1e72f2a6c64f2bec2edbdc0843b7dd8b07e8fd"
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