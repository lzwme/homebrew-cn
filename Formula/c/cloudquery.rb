class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.35.4.tar.gz"
  sha256 "497d9547b942a9c0fe4a445f666de64fe0eddcb7dda310b524ff19039c172750"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11ff60276af8d1fa3d5e0c5c36b9031cbf3d62974658c03854163abf626e29d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11ff60276af8d1fa3d5e0c5c36b9031cbf3d62974658c03854163abf626e29d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ff60276af8d1fa3d5e0c5c36b9031cbf3d62974658c03854163abf626e29d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8c179e10ce5efb17921ca9ce754bc697d93c59edf06b9f68858c3f761ae6e9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9152e16942afd6fab6068d765124fbc32c5e40843eddb3d78d9492dc6e8c8c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67abd452f587951dc32d7fcfce4529ec523808dca2e3496bc6ff9a2774d3fa6"
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