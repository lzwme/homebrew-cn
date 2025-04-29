class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.18.0.tar.gz"
  sha256 "e24abe8d664d90f7e7080e8644b8a0620e1ad600a49544606d317342512e5069"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed55706ae8048d5e2b06241a4606477e8b332383ad98a060a3acbe4aaf3b4008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed55706ae8048d5e2b06241a4606477e8b332383ad98a060a3acbe4aaf3b4008"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed55706ae8048d5e2b06241a4606477e8b332383ad98a060a3acbe4aaf3b4008"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8f3f79a1815cd520f5717e4f841599e42dab2d1dc2c02c98effadeb90916e62"
    sha256 cellar: :any_skip_relocation, ventura:       "d8f3f79a1815cd520f5717e4f841599e42dab2d1dc2c02c98effadeb90916e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da0aa4c2b4e20202af07b8fa1aa5c0adc181a910798ede3656efaf11b367bff"
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