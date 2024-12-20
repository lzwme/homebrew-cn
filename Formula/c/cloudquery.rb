class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.12.9.tar.gz"
  sha256 "dad4fd1f1f37c318bea53561a55c39ef3c89a6f99f746dbbf2931d51deb6af68"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5834f4b8d6138160553c95acc971ae9561bed453655ccfd02c2f81eb6774f2de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5834f4b8d6138160553c95acc971ae9561bed453655ccfd02c2f81eb6774f2de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5834f4b8d6138160553c95acc971ae9561bed453655ccfd02c2f81eb6774f2de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e106ce3c32239d182b907de1475c7a73556a894d31e5b824bcb9657345a62db5"
    sha256 cellar: :any_skip_relocation, ventura:       "e106ce3c32239d182b907de1475c7a73556a894d31e5b824bcb9657345a62db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d82ffdf8a539900db60f724e419726ba07165cadeb03c0f8b52d5dcd8235d2b"
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