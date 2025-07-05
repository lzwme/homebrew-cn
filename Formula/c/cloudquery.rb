class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.21.1.tar.gz"
  sha256 "11efdcb895f0a41a9883fbd2ed09f0f842db7c72d04c05f220e93d27c9682612"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e813d00467a866bb486d407ba014566d5cdb27d7f513db01b63c37006f4aa12d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e813d00467a866bb486d407ba014566d5cdb27d7f513db01b63c37006f4aa12d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e813d00467a866bb486d407ba014566d5cdb27d7f513db01b63c37006f4aa12d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab77e612c3eddf710837cb4969eeab97d25c9ed4e740fa8ed1cd42cd9a799baf"
    sha256 cellar: :any_skip_relocation, ventura:       "ab77e612c3eddf710837cb4969eeab97d25c9ed4e740fa8ed1cd42cd9a799baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a496d791109c6313f9abf7247c8dd6bb154d5ada054250448aa081fe80a549"
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