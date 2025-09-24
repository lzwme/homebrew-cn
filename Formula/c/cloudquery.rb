class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.29.3.tar.gz"
  sha256 "223bed98cd1ecba746422b12f75aa6011861cf6732596bf8b938800132dcb607"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81c8fa7ed92b6a67eac2e41719fd81c04aeb241fcadbf003c09a63fe7f1d61d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81c8fa7ed92b6a67eac2e41719fd81c04aeb241fcadbf003c09a63fe7f1d61d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81c8fa7ed92b6a67eac2e41719fd81c04aeb241fcadbf003c09a63fe7f1d61d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f88046d4a97d31ef66d3a0b68e604cdb3464e7d0e855e1370baa7d0a212df097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a93b6faafdcae4613b5e67b69c87b2f119879cad8ad9250d543664092f67cb29"
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