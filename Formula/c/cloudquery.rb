class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.42.2.tar.gz"
  sha256 "26fa091509597cb51b1feed91540962f17df9cc13aa2d41e2f2f4a9042e7c8ea"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7763e368852bc0d4199a25228af87edc4541e98856457b2d41507b0df81aa62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7763e368852bc0d4199a25228af87edc4541e98856457b2d41507b0df81aa62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7763e368852bc0d4199a25228af87edc4541e98856457b2d41507b0df81aa62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1692db3d11979f9bad3f262dbf450c4cad0ba71631e6aaec0820077bcdb5ff0"
    sha256 cellar: :any,                 x86_64_linux:  "ebf00951d454930a9e4cfae90955f1176bf0d9ab63cfa1b9142ca426c7382f6a"
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