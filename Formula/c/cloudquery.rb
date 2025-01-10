class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.13.0.tar.gz"
  sha256 "750b911ef4e1dc63e03bb5ada28a43c36c5d3e5caa1bd07f135fa14b5db65fae"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b136db4e5431c559080a73779b1bbad545ccb88582124d205250895f58bd5c56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b136db4e5431c559080a73779b1bbad545ccb88582124d205250895f58bd5c56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b136db4e5431c559080a73779b1bbad545ccb88582124d205250895f58bd5c56"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc96179ef62929a57a680d04376a72d5e0d54b232811910f0674d295a0b7cd7"
    sha256 cellar: :any_skip_relocation, ventura:       "4cc96179ef62929a57a680d04376a72d5e0d54b232811910f0674d295a0b7cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db028946cff4bdcaf371a9780a4a9f972be56eafd87aed5388f5b3970e10a95f"
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