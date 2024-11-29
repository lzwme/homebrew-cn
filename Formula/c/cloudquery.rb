class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.12.1.tar.gz"
  sha256 "3fc269fda9b26208cd862e5ec532e2a95862d93fb343953b7845724ba9425333"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f726f04b56c713027d99f17f4bbb509b3d20c9631206fb652c654a953b9c47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19f726f04b56c713027d99f17f4bbb509b3d20c9631206fb652c654a953b9c47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19f726f04b56c713027d99f17f4bbb509b3d20c9631206fb652c654a953b9c47"
    sha256 cellar: :any_skip_relocation, sonoma:        "6757c17c412979380a056fb39a66e0bac65e4a57274efdcb8f15d8e0c134bb06"
    sha256 cellar: :any_skip_relocation, ventura:       "6757c17c412979380a056fb39a66e0bac65e4a57274efdcb8f15d8e0c134bb06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12f39a96162dc442e9c5e9ae27a4ffbdbf94a4c761f4c76e448d52be6995d2e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comcloudquerycloudqueryclicmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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