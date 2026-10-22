class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.49.1.tar.gz"
  sha256 "11dccfb732a5367888db9543da7b9b233510847643a209cab1d90a35e85175fb"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc85199576c5b6245dce34245fd0b84625f3da1662fe90889c83bb6b1712033e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc85199576c5b6245dce34245fd0b84625f3da1662fe90889c83bb6b1712033e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc85199576c5b6245dce34245fd0b84625f3da1662fe90889c83bb6b1712033e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "849654f8253c78c4cfd3e05e76cdc959c5a734870e9c779d67559363d5d1bb1f"
    sha256 cellar: :any,                 x86_64_linux:      "ec22037f8ee895f9635d051c5df96a1c23f0ea4a0cc315e29cac0a8d6fabac91"
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