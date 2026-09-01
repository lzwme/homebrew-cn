class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.41.2.tar.gz"
  sha256 "a6f78d4fc5540a8fbf422dcc3fd9c3b8920c134ae461f4af022138aab98715b3"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e2dee56c20540224ca7e448ebd6f0eabdfd0e626ddebc111110aa19e333e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2dee56c20540224ca7e448ebd6f0eabdfd0e626ddebc111110aa19e333e1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2dee56c20540224ca7e448ebd6f0eabdfd0e626ddebc111110aa19e333e1ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f102cdd08c263288d35e94c5c28e2466cd9ed548ce108e6cd00737df9af6fc4"
    sha256 cellar: :any,                 x86_64_linux:  "a6306e3d1e2cd232c5f8ae364b60bd3eb0198debc5d852980ced49f7a6a6eebe"
  end

  depends_on "go" => :build

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