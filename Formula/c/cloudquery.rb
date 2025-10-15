class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.30.0.tar.gz"
  sha256 "87dfc440caabf12b9f91602593ce6ad26ed897bb4673e769c4084b1e12fd4ee3"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b390b953f14e11942401ae3aea26f273d641187682b8c788ea9614ccdea57b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b390b953f14e11942401ae3aea26f273d641187682b8c788ea9614ccdea57b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b390b953f14e11942401ae3aea26f273d641187682b8c788ea9614ccdea57b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1748bf0615624535acc6da0e87c76f59e1905cf8a99435a1940064f4e1980bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9246b5890d373442e564d15dca39b86377c94328fb43919c5f6b2ae1ecc0faaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f93325ff86c092dda398317956df202755a23d3b19aa2cb0d77cd2dd2b07e9a"
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