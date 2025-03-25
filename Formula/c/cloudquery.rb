class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.17.0.tar.gz"
  sha256 "05690c2aaed0617f8cfdd9a0050fcd3096e28a2c8a08ba130dd0e7347a2a992b"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e952bd0a2df58cc7764156691300982ccfdc61b8909758764956277490b01435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e952bd0a2df58cc7764156691300982ccfdc61b8909758764956277490b01435"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e952bd0a2df58cc7764156691300982ccfdc61b8909758764956277490b01435"
    sha256 cellar: :any_skip_relocation, sonoma:        "f71cab2dfc2052c54d1a76146d75bc9a2de957870ba2451fbc9d0102402417af"
    sha256 cellar: :any_skip_relocation, ventura:       "f71cab2dfc2052c54d1a76146d75bc9a2de957870ba2451fbc9d0102402417af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "741d17286dffcc163b23ae98cb4b589426ed34838894b0ff1787640b5a4379a2"
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