class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.26.0.tar.gz"
  sha256 "c1000f4814b7a7727fa4b76e7c69186f11f94703283e9d16c1c3a4befa649c72"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362cac5fa16f7a210ecaac11650cd9533ac649cc9d192e4397032d9c1466e101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "362cac5fa16f7a210ecaac11650cd9533ac649cc9d192e4397032d9c1466e101"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "362cac5fa16f7a210ecaac11650cd9533ac649cc9d192e4397032d9c1466e101"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ca34cc24acc73bf8cac058067c1ae25e58d1a9a30208a029f27c3eeffaf3fb8"
    sha256 cellar: :any_skip_relocation, ventura:       "3ca34cc24acc73bf8cac058067c1ae25e58d1a9a30208a029f27c3eeffaf3fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51da87ef003cdf21a0c39e2798f458147c8bc0fc67054a98ca0b10598e27c95f"
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