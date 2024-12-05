class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.12.6.tar.gz"
  sha256 "7e2f34b7a70c8c91819de1d140bfdd838b84eb19253cda5cc1507b50c4a8eebc"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cb1f4c44b5ca931b818a9d466a4ce2e79a2f9c6e84867e785f1818970df9a48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cb1f4c44b5ca931b818a9d466a4ce2e79a2f9c6e84867e785f1818970df9a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cb1f4c44b5ca931b818a9d466a4ce2e79a2f9c6e84867e785f1818970df9a48"
    sha256 cellar: :any_skip_relocation, sonoma:        "444df890911969e65eacf978ce944b4acb148b621432f568bd18f694b20368fe"
    sha256 cellar: :any_skip_relocation, ventura:       "444df890911969e65eacf978ce944b4acb148b621432f568bd18f694b20368fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c51b916059c73770a78dc855c779fa8f20e50181122cac93ef992f2857a88c"
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