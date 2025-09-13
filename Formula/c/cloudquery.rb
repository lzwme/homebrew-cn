class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.28.1.tar.gz"
  sha256 "c4ee790ac22f3611c63432d5b5204b0388e16dfdb529cb85a097803b8d6465a2"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85a15f16984c95f51d712b00581683e29b2347520ba60e5534434b280faaca1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85a15f16984c95f51d712b00581683e29b2347520ba60e5534434b280faaca1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a15f16984c95f51d712b00581683e29b2347520ba60e5534434b280faaca1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85a15f16984c95f51d712b00581683e29b2347520ba60e5534434b280faaca1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed708928eb29adb7660bccecfc9bf95166ac4d7c1d22f2f70184f8ecabea085b"
    sha256 cellar: :any_skip_relocation, ventura:       "ed708928eb29adb7660bccecfc9bf95166ac4d7c1d22f2f70184f8ecabea085b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bbc74808ff33e3db804bb609b19c721f14b80091ed42831972debb9e14a16c1"
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