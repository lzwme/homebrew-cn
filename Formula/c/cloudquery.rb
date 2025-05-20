class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.20.0.tar.gz"
  sha256 "4ca8f02f5c43b6325f031bbd7b2dc041abc74f59067b6af7e5c1670567b42d33"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743a9454a19317f4dcfe7d677d39d40b823f8e039fd01d9085a439521dd19b0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "743a9454a19317f4dcfe7d677d39d40b823f8e039fd01d9085a439521dd19b0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "743a9454a19317f4dcfe7d677d39d40b823f8e039fd01d9085a439521dd19b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed687692e2daeddf53fdf759cbbf2aa3e5bf5b04c5bb5e41d84e888b4989ebe3"
    sha256 cellar: :any_skip_relocation, ventura:       "ed687692e2daeddf53fdf759cbbf2aa3e5bf5b04c5bb5e41d84e888b4989ebe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410440040cf1d8f954dd8f76efcd88422c3dd88ca583f11f9d6f8f7309b50412"
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