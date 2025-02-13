class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.15.2.tar.gz"
  sha256 "b8b63af7af3fd30997091304fac1fa967f92f514722f502755961e9fa12146d7"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4985553008ef0dbba2b7920eaf1e1b856ba3a2a3b4403ed4a0615f9453d0b795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4985553008ef0dbba2b7920eaf1e1b856ba3a2a3b4403ed4a0615f9453d0b795"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4985553008ef0dbba2b7920eaf1e1b856ba3a2a3b4403ed4a0615f9453d0b795"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5ab02e22d89a0b7698f69b990df37a249ad713a8ff917572e2df3765db48032"
    sha256 cellar: :any_skip_relocation, ventura:       "b5ab02e22d89a0b7698f69b990df37a249ad713a8ff917572e2df3765db48032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90ed801f361e2675928c4cfb1c6dd49e73591dfcee4cb062f050fdf1cf435a30"
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