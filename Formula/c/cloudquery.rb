class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.31.0.tar.gz"
  sha256 "6c8d41e8abd0c63b1a70d5607fa5daa427e28a4f624eb8cd37a3e14db73e7c6f"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1ba5cb48f9b89d716650eadd093bc8aa78a382bd31071a167c1ca77ec8d9158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1ba5cb48f9b89d716650eadd093bc8aa78a382bd31071a167c1ca77ec8d9158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1ba5cb48f9b89d716650eadd093bc8aa78a382bd31071a167c1ca77ec8d9158"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7ce46d959e7c83e5045de91e60aad36fea6c12eddfa978665ceb3ce4b3c755c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e65406229ce5acacbc714d7b5e7d3f5a37a885187291931aa02b4907d3e43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10db5d83916876a7a601fae121cf0dd2b31488a6a9d50b9c4a3e4931ff95d9d3"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end