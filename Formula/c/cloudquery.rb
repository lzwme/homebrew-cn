class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.38.0.tar.gz"
  sha256 "cf295ed993a529e01a68c832cc483d5e7648e55b2425419b5fbfa0181c5ab3e2"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a21b24e8faf0193151627e9a39d0c6f3459a65d950f4bc2f157df0f1c8a368e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a21b24e8faf0193151627e9a39d0c6f3459a65d950f4bc2f157df0f1c8a368e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a21b24e8faf0193151627e9a39d0c6f3459a65d950f4bc2f157df0f1c8a368e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded4c34093db8bd8aba3497c9f84e6c8d2c345b1e99c403415bfd8aa9d2c07ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7125aea569e4f6e2d79a31a925b1def4cde147afd44cab19dab80b7cf059c248"
    sha256 cellar: :any,                 x86_64_linux:  "2eedc639d1d80ed27a5117c31e45af6702be2e338fa787d03e6e4e783e3245b1"
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