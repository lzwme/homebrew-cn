class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.32.0.tar.gz"
  sha256 "bd80c3c02ba63b3af72a9b1123484a63035f923776735ea3c723a2a2e2f5ba24"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac207904d1d90fa772803e39ce5ca41f78f62505723a9abb4e24ced43e1df9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ac207904d1d90fa772803e39ce5ca41f78f62505723a9abb4e24ced43e1df9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac207904d1d90fa772803e39ce5ca41f78f62505723a9abb4e24ced43e1df9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e5272ddb5bdf5170742392a8d46386966c0322e3562ccb35e7cb9cc6a6a57d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5024df2b52a0fae009f5ef8093fc4b78f5c0e6dc2dd687d55d14557e32a83327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec68c36198f09d770a93cc1107242301aac4f3df56c345fd5f5aca24840a43e2"
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