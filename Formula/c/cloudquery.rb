class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.20.4.tar.gz"
  sha256 "b9e37be424e802df4c667c7798a0f607bf1167e90eca5d82e31adad4b5ba09fa"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae325f24dde0fbe224e05131e3c81f29df9763935cef619b8743d77a6b146442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae325f24dde0fbe224e05131e3c81f29df9763935cef619b8743d77a6b146442"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae325f24dde0fbe224e05131e3c81f29df9763935cef619b8743d77a6b146442"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab736d7b8636dd128b3748ef345ff4c32ac579cfa5dc2b46bc08f72928622e0f"
    sha256 cellar: :any_skip_relocation, ventura:       "ab736d7b8636dd128b3748ef345ff4c32ac579cfa5dc2b46bc08f72928622e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f97a1eef37777723c9230b16ff490fb20ea6d2679cf0b280c89c7bf784ab3c"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.comcloudquerycloudquerycliv6cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath"cloudquery.log"
    assert_match <<~YAML, (testpath"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudqueryaws
    YAML

    assert_match version.to_s, shell_output("#{bin}cloudquery --version")
  end
end