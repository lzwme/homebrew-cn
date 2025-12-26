class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.33.0.tar.gz"
  sha256 "30720968d68cfab0983af0c8034213ac2d5fb0d4d91e8abd11fef23536005c39"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f9208e2b207335f38398e5c09a2e21fa6643a0039a34813b6c055900393fc36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f9208e2b207335f38398e5c09a2e21fa6643a0039a34813b6c055900393fc36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f9208e2b207335f38398e5c09a2e21fa6643a0039a34813b6c055900393fc36"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e6c33d5a1fd5f1521b67bbc2fd97fce5b04e3fde1bd451e7b2b5bd6e587036a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d93362d07c8787e4d618675dc791b0e5e23ca104824c9d8f2d5a71ab8034b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cac07cd0e0b33a9d245d37998c7a72dab4dfd7e84f5e37ccf66de75583d0346f"
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