class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.26.3.tar.gz"
  sha256 "1ccc17f9b85de742f5166d5ea68a8b3d155b1fd1237121e69ecf3760b675f2ef"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a7d42b5eb003ac1bbf1652a3687892e9b645108fcfbe6317e771f1a4ddde4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a7d42b5eb003ac1bbf1652a3687892e9b645108fcfbe6317e771f1a4ddde4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44a7d42b5eb003ac1bbf1652a3687892e9b645108fcfbe6317e771f1a4ddde4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf2e3d30d88ad8b2ea22a94eea83251f9c1029ae85dc1494d11c94969124af58"
    sha256 cellar: :any_skip_relocation, ventura:       "bf2e3d30d88ad8b2ea22a94eea83251f9c1029ae85dc1494d11c94969124af58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebbd1655ed0b2f48a486d5647e3b8c79ff46c0b927b221f56b0f59076bddc593"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
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