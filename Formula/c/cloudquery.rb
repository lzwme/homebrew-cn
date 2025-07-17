class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.23.0.tar.gz"
  sha256 "b174ec50b56d6e3c0a787932ff671b4e85a57f32485bec7b3d7934f4901a3210"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ecef1e03ac0aa45e5647b3304070892fadef28e1027112e9e4366e9f83e48e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ecef1e03ac0aa45e5647b3304070892fadef28e1027112e9e4366e9f83e48e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2ecef1e03ac0aa45e5647b3304070892fadef28e1027112e9e4366e9f83e48e"
    sha256 cellar: :any_skip_relocation, sonoma:        "64645d9707895ae33f47ff340bcb139959076c2e0223cc93beebd7bc7201f71a"
    sha256 cellar: :any_skip_relocation, ventura:       "64645d9707895ae33f47ff340bcb139959076c2e0223cc93beebd7bc7201f71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5ecd212cb2fae182eb3c3c113b11dd77411b2918b9e3ab6f41d376a4bb7468"
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