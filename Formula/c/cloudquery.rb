class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.29.4.tar.gz"
  sha256 "33e8b0e52fa7afb52e22b0806b254142d9fc6dd7abc58ca29bcbededa126c5b9"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7a320377c070b95b6e88fc5bff35e762672861643d1dcea3fca28040555fbe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7a320377c070b95b6e88fc5bff35e762672861643d1dcea3fca28040555fbe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7a320377c070b95b6e88fc5bff35e762672861643d1dcea3fca28040555fbe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a46b014e996edf42a242a9bc1e0b485fd4f7ccd9d9c4bd721f7c19da6635d24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1b2ad7cc471df33523f18feeab35f994c1dce7f0be1e8686adcb80cf571348b"
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