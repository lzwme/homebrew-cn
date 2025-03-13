class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.15.5.tar.gz"
  sha256 "6712dbc39f648095d136a0e610c2a1f86ffa33a0b441e52155c0d7f0afa1a65d"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c2edcf1c830640827cad0b219d7004943036125e2b97d9a9d1be43e6b04d9a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c2edcf1c830640827cad0b219d7004943036125e2b97d9a9d1be43e6b04d9a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c2edcf1c830640827cad0b219d7004943036125e2b97d9a9d1be43e6b04d9a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2644fa03d5b3b85dc4b254683f7ae14aa0aefa689c1ea7046eeb4be5115691b"
    sha256 cellar: :any_skip_relocation, ventura:       "e2644fa03d5b3b85dc4b254683f7ae14aa0aefa689c1ea7046eeb4be5115691b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433decdf88b5dd2d6fae84cf65fc5108e714773b700bdafcc7a7e3531885ef43"
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