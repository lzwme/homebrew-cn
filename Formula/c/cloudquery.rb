class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.39.0.tar.gz"
  sha256 "ad6cc2855759298ab7e154c096e95cd9cdcad463cf8fb707325fc532ae963ee8"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0607cd4fb2cbaa1760e200c5bb61b3ebf3ddebd67fe1da09e82f6b42085988c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0607cd4fb2cbaa1760e200c5bb61b3ebf3ddebd67fe1da09e82f6b42085988c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0607cd4fb2cbaa1760e200c5bb61b3ebf3ddebd67fe1da09e82f6b42085988c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a39a0b4bf2f048e11f229eb4c3014ed4378484584a52babee1d5747656dd7149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6118cff8c369fe863a280dc9f68c7575389560c13023168572a4ea99b1da6fbd"
    sha256 cellar: :any,                 x86_64_linux:  "804c1a0348701c1640674abb5d43b1b45402b47eb49cd724b2d5b092c28041b3"
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