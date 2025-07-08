class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.22.0.tar.gz"
  sha256 "a23e2f6ebc7d9ee4c857dbd8adf908ac2c2ae5da84bc1b1312a9c2a6473857ff"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0ac44164fb6cb00d288e9abe81d8d01ce115e8d7ae0abdcb56b5b1eee1d6fe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ac44164fb6cb00d288e9abe81d8d01ce115e8d7ae0abdcb56b5b1eee1d6fe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0ac44164fb6cb00d288e9abe81d8d01ce115e8d7ae0abdcb56b5b1eee1d6fe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5987ad1241795024e5ab48515fa9ef40575339d44b4d32ec5992020470f2d9f"
    sha256 cellar: :any_skip_relocation, ventura:       "c5987ad1241795024e5ab48515fa9ef40575339d44b4d32ec5992020470f2d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9702e921b1f891f4c7e0c5aae220394a252db4e3ef3369f4cd1b1c1c32f1ee3"
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