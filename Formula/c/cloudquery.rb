class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.25.1.tar.gz"
  sha256 "121d3a6da3f2f12a40db7c99c45eaa19fdef2527802790710870d55edf3e3030"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62a27caca30862c62ef27345e4b9871a089e9f01c9dc3fa920a5b208aa16bb75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62a27caca30862c62ef27345e4b9871a089e9f01c9dc3fa920a5b208aa16bb75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62a27caca30862c62ef27345e4b9871a089e9f01c9dc3fa920a5b208aa16bb75"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9f8eb4829db5c8d7b1892c27d8c0e8924a21391a4e9656769a89b51fa29d311"
    sha256 cellar: :any_skip_relocation, ventura:       "f9f8eb4829db5c8d7b1892c27d8c0e8924a21391a4e9656769a89b51fa29d311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "374cfd08e2f82e5cf95f44597e6ef7511cfed5b9effa61a589b2b48c76e5ec8d"
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