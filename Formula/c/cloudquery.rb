class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.30.1.tar.gz"
  sha256 "87c1d9c3bf83e847dca87db9786351c98aee1f8364449992a40e56b931b925b7"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69fd6d49d38728dc813d30c6f9ceb7c98a717183e2c18a0469f246675c2751d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69fd6d49d38728dc813d30c6f9ceb7c98a717183e2c18a0469f246675c2751d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69fd6d49d38728dc813d30c6f9ceb7c98a717183e2c18a0469f246675c2751d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5e4f1c52d0ffa1c7cb28642802c5d68a8157c56a6be9bcc901ccf3915ced0c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8f4123c6ff28c6e6a64409469ff2db49951196807f82f224f04e7b3f66cf0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135ff7e9ef403ec0ddc807bc621c084505b4878d5c228d5d6946d91b20af9b74"
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