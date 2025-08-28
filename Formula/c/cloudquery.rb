class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.27.1.tar.gz"
  sha256 "04baf8b60ac9b6d7ab74fb9bb3a910910f2e01bbeb035beea7f3a392566c68b4"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf8aa7359b8143a16371c47ae6e4e46fcb91de324b75c05c090b69bf3af6fd5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf8aa7359b8143a16371c47ae6e4e46fcb91de324b75c05c090b69bf3af6fd5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf8aa7359b8143a16371c47ae6e4e46fcb91de324b75c05c090b69bf3af6fd5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "06992a10794ef4ccbb9498bd33380811de09243ff9e318f6b424ce8a21e25e0f"
    sha256 cellar: :any_skip_relocation, ventura:       "06992a10794ef4ccbb9498bd33380811de09243ff9e318f6b424ce8a21e25e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091b7a8ab3e3dbd090b5cd8c2e7d256092aa09bd77b87c923cfffd4fad83f224"
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