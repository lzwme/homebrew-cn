class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.35.6.tar.gz"
  sha256 "644ca248b4b448d35f296ff61d8c0500fcc98866a39829577495866d7da96299"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6b546d332f7ad796826b29641d398560fe4a8e2647d353323bde8c2ad3688ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6b546d332f7ad796826b29641d398560fe4a8e2647d353323bde8c2ad3688ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6b546d332f7ad796826b29641d398560fe4a8e2647d353323bde8c2ad3688ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b9ba04b4cba79e22cf1089d4289cceee47eba10f1c967bb05f8b11ca22b226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c2d31e27f8d28201174bfef7149dd64969bfe903de54d70bd262496fb9f557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5781e3885e35646a7d9d5d484e867c47c21a31ce586a99c37870e724eb2d3579"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
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