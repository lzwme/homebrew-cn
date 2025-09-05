class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.28.0.tar.gz"
  sha256 "65f4f6006ed4a32b6df12a183e06b8453cd9ea268536656713ed126722047da9"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a65121220023cf7b562d5c0470d7419edc5216a75d0054503bb87d4a55a6d80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a65121220023cf7b562d5c0470d7419edc5216a75d0054503bb87d4a55a6d80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a65121220023cf7b562d5c0470d7419edc5216a75d0054503bb87d4a55a6d80"
    sha256 cellar: :any_skip_relocation, sonoma:        "958c0dfdc1d31fccd4aa5fc33e2b089e25631f635ef7017994e0cce25bab8d52"
    sha256 cellar: :any_skip_relocation, ventura:       "958c0dfdc1d31fccd4aa5fc33e2b089e25631f635ef7017994e0cce25bab8d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0dd51175aecbf267100aef0f57eef4a4f40525191cc06d4962c78aab05abd9"
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