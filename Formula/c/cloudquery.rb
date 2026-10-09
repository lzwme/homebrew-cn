class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.45.1.tar.gz"
  sha256 "dbe0e0f7d32b1032bf129411db473d67bc68375ad87f4bbdb917899acd1005a9"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de74772b92cc29988759d85c726b3a55ed29f3915f6c310f1dfe13edc8347891"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de74772b92cc29988759d85c726b3a55ed29f3915f6c310f1dfe13edc8347891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de74772b92cc29988759d85c726b3a55ed29f3915f6c310f1dfe13edc8347891"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23d46bf9e9281261eeaa4dd9c131c1fb06017dec1e0fd1151bdab0a4eafdb0e4"
    sha256 cellar: :any,                 x86_64_linux:      "65f40dd97a320cb258eb17f28867f6ed70263a0e4dfb414b9195e36fc333213e"
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