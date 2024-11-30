class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.12.2.tar.gz"
  sha256 "166c2f21363150564cfb23b85f4a8f9f339e88510df62eba5fc6a58c31fd6dd9"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dd73c3eb115d90e1f63d070c34bc6331db7a7c535108d16dd69e0ac1a28d2ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd73c3eb115d90e1f63d070c34bc6331db7a7c535108d16dd69e0ac1a28d2ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dd73c3eb115d90e1f63d070c34bc6331db7a7c535108d16dd69e0ac1a28d2ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "a40f4fa76a24f6a3bf5c6f29c66a05a2c64ff90df346b27f31b693a4395289a6"
    sha256 cellar: :any_skip_relocation, ventura:       "a40f4fa76a24f6a3bf5c6f29c66a05a2c64ff90df346b27f31b693a4395289a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648498b3c2dc93e774aeafb8db63707a40bb8e31881f60edcb1ce6df4b52ea83"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.comcloudquerycloudqueryclicmd.Version=#{version}"
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