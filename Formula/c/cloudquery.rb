class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.20.2.tar.gz"
  sha256 "c318f3f52f3bcf43213a7530ae701731b49d306c09e90c7c1f2f568cd949c551"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59268e91430ea29a42f418255ed641bb3e1f23786e4e4041cde4ce618a0761f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59268e91430ea29a42f418255ed641bb3e1f23786e4e4041cde4ce618a0761f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59268e91430ea29a42f418255ed641bb3e1f23786e4e4041cde4ce618a0761f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ad8521743f923022576ca5c8366cc0dddd978a6ea14e9d9af855b5435c07406"
    sha256 cellar: :any_skip_relocation, ventura:       "9ad8521743f923022576ca5c8366cc0dddd978a6ea14e9d9af855b5435c07406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275a8a342643dfa9c29b76f4bfbb34c1b128e209a72b3a2eb54ae2489018fb33"
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