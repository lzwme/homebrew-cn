class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.19.1.tar.gz"
  sha256 "cc73e7b37e619d99417e54f7a498d2ad17b31601e6a1027b43fec9fe13ea2286"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0271f46a028b0b6e0ba5e2410dd7f56fcc867d5aa57f3ad15e02c2ce6d2eced9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0271f46a028b0b6e0ba5e2410dd7f56fcc867d5aa57f3ad15e02c2ce6d2eced9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0271f46a028b0b6e0ba5e2410dd7f56fcc867d5aa57f3ad15e02c2ce6d2eced9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d696838b4b55ab58b3f07181bcce418e24757727bf20c4f68538b51a5efe4fd"
    sha256 cellar: :any_skip_relocation, ventura:       "5d696838b4b55ab58b3f07181bcce418e24757727bf20c4f68538b51a5efe4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f41375370f62558b97798e818c44a403a3390a6be245f84d1456f06f160bde45"
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