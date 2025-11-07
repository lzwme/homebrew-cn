class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.30.2.tar.gz"
  sha256 "fe32c1620f5b4b6e006eb3f6e002be8c8ec169ef9046fa35d1374f63e34a2952"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ad993bb0f9aef634a9d88e7d1d648de83a9207ab78300938480354177fac453"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad993bb0f9aef634a9d88e7d1d648de83a9207ab78300938480354177fac453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad993bb0f9aef634a9d88e7d1d648de83a9207ab78300938480354177fac453"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b3a61f20a3dbbc7043e9d5ecf61b066393b28c1ab23e3d5ae6e28cca803706c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244e228116bec61888d6db30b8d539d3e1149e55571d7ff3016256ad69739dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f523afd0e6401d3088635d026cdfe8e251beb8ced96dc336bb37fd5d8707c74"
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