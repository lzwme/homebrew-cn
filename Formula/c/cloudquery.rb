class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.34.3.tar.gz"
  sha256 "02f458a88b9ae4fd0cf6781256daad9ebf16a0d04c3efc6edbe707e01fec0339"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aad7390f5bed4473e4bf309ef7fd14ccf5467399aa0de1fcee513c0e717f67e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad7390f5bed4473e4bf309ef7fd14ccf5467399aa0de1fcee513c0e717f67e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aad7390f5bed4473e4bf309ef7fd14ccf5467399aa0de1fcee513c0e717f67e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e79e1a1de2ee00ca7e4d24239b0c260ef96a1e20a4432b23094026506b586a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d07ab3188e2610c109f2ddc543ce26f6f45802c184d4452c5451537e0db4f933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae2a4d4d04f2329a3837dd3454e49980d1fc73552374a834eac811137409202a"
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