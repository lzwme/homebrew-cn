class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.15.0.tar.gz"
  sha256 "acdef2dcf96c25851e4a30469cc02ffdaf8c6b2c0c0e47e54568267657ab1025"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ef32034cccaecd913551094673610204f86fb49c28467734e42b806ec9807b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ef32034cccaecd913551094673610204f86fb49c28467734e42b806ec9807b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ef32034cccaecd913551094673610204f86fb49c28467734e42b806ec9807b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f199be58e5878ecf4d101ff0acfdf13dc531300716e34559a4f78e6e530f3f"
    sha256 cellar: :any_skip_relocation, ventura:       "b2f199be58e5878ecf4d101ff0acfdf13dc531300716e34559a4f78e6e530f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "030fd968f3932f92974cf4f437c5d0f29c6fa85825032500a15348316e4379c0"
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