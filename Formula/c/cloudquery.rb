class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.17.2.tar.gz"
  sha256 "9fa0805c4f0b1f21596f7de9ad6745e2c4982f33f82d6f3c7c2364ed9939f3a4"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a220f8242ce8fcaaa10ebcd98427ac0ba8c6b85d1fb8ba552281b372909a9ee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a220f8242ce8fcaaa10ebcd98427ac0ba8c6b85d1fb8ba552281b372909a9ee5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a220f8242ce8fcaaa10ebcd98427ac0ba8c6b85d1fb8ba552281b372909a9ee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad530a2dd4d57ef1b9afb01c8f6b8eb5dc266c02bc41afd0d99c954a93217f07"
    sha256 cellar: :any_skip_relocation, ventura:       "ad530a2dd4d57ef1b9afb01c8f6b8eb5dc266c02bc41afd0d99c954a93217f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87b0a6c6d65ffa7a0a86eb28a7d0b24baa3a9365e4ca7a31ce472db78d6eaa2"
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