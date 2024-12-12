class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.12.7.tar.gz"
  sha256 "bbf105e6ab00f2657918fbf3dcfa3ae1acc335fde44e8834c2e57a67cab2ca19"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3a825fd6fe3f35877aa8ffe0df59aa4060bfcf80997479e5252b36a201b451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3a825fd6fe3f35877aa8ffe0df59aa4060bfcf80997479e5252b36a201b451"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a3a825fd6fe3f35877aa8ffe0df59aa4060bfcf80997479e5252b36a201b451"
    sha256 cellar: :any_skip_relocation, sonoma:        "79e00be3674df00d94486f23609d1319992a3601bd02cbcec8625deec277325d"
    sha256 cellar: :any_skip_relocation, ventura:       "79e00be3674df00d94486f23609d1319992a3601bd02cbcec8625deec277325d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9f8f8bed57074a2d4a8601b0be23e03d3586654fa06c1f64c3f5520f2743cc6"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.comcloudquerycloudquerycliv6cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath"cloudquery.log"
    assert_match <<~YAML, (testpath"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudqueryaws
    YAML

    assert_match version.to_s, shell_output("#{bin}cloudquery --version")
  end
end