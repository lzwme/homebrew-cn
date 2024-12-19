class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.12.8.tar.gz"
  sha256 "91be0f83169e2d086bc205c6bd8737c7d90f68c37e96369ad86725869207f02e"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f9398e834aad0beea705e6db8393557197379e007c15a877a15ab149ae72623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f9398e834aad0beea705e6db8393557197379e007c15a877a15ab149ae72623"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f9398e834aad0beea705e6db8393557197379e007c15a877a15ab149ae72623"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbca8b0b58424f819fafd387ea424dda3a3cab961355bea4dbab3caa02ad8e7f"
    sha256 cellar: :any_skip_relocation, ventura:       "dbca8b0b58424f819fafd387ea424dda3a3cab961355bea4dbab3caa02ad8e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84bec8b57b2ebbaf1b0ed4915cea7721798138778acda801c9a8e41800acb501"
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