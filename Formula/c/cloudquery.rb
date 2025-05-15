class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.19.2.tar.gz"
  sha256 "d72abae4e4c47f4ea0bf206a8baf64103865b0115df7f60b6f49759ec82b328e"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aaab23f208cf29ee769f9d8731561640af1a3c56579428af2d69c946f4650b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aaab23f208cf29ee769f9d8731561640af1a3c56579428af2d69c946f4650b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7aaab23f208cf29ee769f9d8731561640af1a3c56579428af2d69c946f4650b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6d5e98690c92e9eeea4545a7adff6031dc005d38a37295a5b8d242ac8fcbce4"
    sha256 cellar: :any_skip_relocation, ventura:       "f6d5e98690c92e9eeea4545a7adff6031dc005d38a37295a5b8d242ac8fcbce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1734538381b62d4e8b66bd1f76b0af95c438cb18443cbe6deae9be585d63c2c1"
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