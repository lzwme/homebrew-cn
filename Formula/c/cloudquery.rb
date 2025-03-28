class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.17.1.tar.gz"
  sha256 "09b111125d40e823a3a21120ad87ce7469924c7257718baf27198b0435ef6276"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83c33d4521ae50f708438b3be82ced3c7631ceece66b507477ce2fa929af8040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83c33d4521ae50f708438b3be82ced3c7631ceece66b507477ce2fa929af8040"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83c33d4521ae50f708438b3be82ced3c7631ceece66b507477ce2fa929af8040"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae398b6fde66990d9221f7051f093bed8795b3b641bfd0ddcff3c5088dc092e2"
    sha256 cellar: :any_skip_relocation, ventura:       "ae398b6fde66990d9221f7051f093bed8795b3b641bfd0ddcff3c5088dc092e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c56d1b6966109bbf0f8a2fdfa72fac273c4abeb950f1072e22cd58b2a6fb7836"
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