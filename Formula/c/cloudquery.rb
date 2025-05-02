class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.18.2.tar.gz"
  sha256 "bc6d8c47a4179e4e517b6dc676edcdf6f388e9ae0515fddb3c992c4e42157081"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ec7221de81990aa4824a36ca6300274909be2e20154241f834c0bffa3a21ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ec7221de81990aa4824a36ca6300274909be2e20154241f834c0bffa3a21ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2ec7221de81990aa4824a36ca6300274909be2e20154241f834c0bffa3a21ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eebc525c4ad732d9d09750887062aa82318923e0c40fd5d60159ea3e59edb49"
    sha256 cellar: :any_skip_relocation, ventura:       "0eebc525c4ad732d9d09750887062aa82318923e0c40fd5d60159ea3e59edb49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ec7dc478f9301de80ee49baa368fa56549def6d7194217e75a1f61815560fc"
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