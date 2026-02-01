class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.34.1.tar.gz"
  sha256 "f5c866ef555c7fe9fab70e4d8ac56d9fc270f1fe98656e58a46d87b46f7aeab6"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6d3a521e694c80dd0511e87d320577834eddcebac3b92e2af39b5b0f61b9928"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6d3a521e694c80dd0511e87d320577834eddcebac3b92e2af39b5b0f61b9928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d3a521e694c80dd0511e87d320577834eddcebac3b92e2af39b5b0f61b9928"
    sha256 cellar: :any_skip_relocation, sonoma:        "267376971875092fba55cc421c3b6b065ac2f6f7a3b5b5413dfad5068a35ce10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "530537abbf36d5e87540ca42f20a12c296edbc1997db804014e87242df8eef64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2c17f3d98acc31fac93cab7d8b6675e15c25a3ed2ce3391c32076619d932ab9"
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