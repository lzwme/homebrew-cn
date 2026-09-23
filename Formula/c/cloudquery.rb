class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.43.0.tar.gz"
  sha256 "6f817f48c91360e115b0b12aedc2b4b8b2f974c5441be577ac8ff7099a68c3af"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9dd8f2d66ef0d9f50445f879ebd750c0e81b7ca75cd151af29809c38b1e99ce3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9dd8f2d66ef0d9f50445f879ebd750c0e81b7ca75cd151af29809c38b1e99ce3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9dd8f2d66ef0d9f50445f879ebd750c0e81b7ca75cd151af29809c38b1e99ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21aeffbea1f665f15e5f19f54729148f3bba3171424d24ba4ffc6386f50f52ed"
    sha256 cellar: :any,                 x86_64_linux:      "0f49c08daebbeb662382d33467382fe7b977aa822426183375a58b41787492af"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "cli"
  end

  def install
    cd "cli" do
      ldflags = "-X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
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