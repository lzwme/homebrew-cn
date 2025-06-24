class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.21.0.tar.gz"
  sha256 "e92e4a2c8142d34fdf94f6333dd698093674fbe36ea0624290a12f318255e909"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7394d9afb796741a620d511ef7692a7b674804003e075781bc79cdbcb500743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7394d9afb796741a620d511ef7692a7b674804003e075781bc79cdbcb500743"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7394d9afb796741a620d511ef7692a7b674804003e075781bc79cdbcb500743"
    sha256 cellar: :any_skip_relocation, sonoma:        "27bcacaa7ebc0aff57871d009595da2229f396936c1297a3bb24e8e622102636"
    sha256 cellar: :any_skip_relocation, ventura:       "27bcacaa7ebc0aff57871d009595da2229f396936c1297a3bb24e8e622102636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd83a5ba43e4e9f13c64f6f3f88ac79b2e88b41224f915115cff7f77a93987b1"
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