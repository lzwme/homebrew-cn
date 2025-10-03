class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.29.6.tar.gz"
  sha256 "e58c3487fd920cb5c7d4c0bfc97551b1dad4e61e72b48dc021778ac2591d763d"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69f256818d5b1fb9d2dedf97f048308a0f6610eefad52c98b2e96a6d36ad0545"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69f256818d5b1fb9d2dedf97f048308a0f6610eefad52c98b2e96a6d36ad0545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69f256818d5b1fb9d2dedf97f048308a0f6610eefad52c98b2e96a6d36ad0545"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ffb54ca18187f2877babf07ff334bfcb712c3843c61875de1ce72a979d6235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5a0e7b422c6c6490aa8458c6dd836fc745e17b11be0ca6bcb88f7e2ecb97a35"
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