class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.20.1.tar.gz"
  sha256 "9f68801737cc304b85ff74aa66f152728683429d8e97f1ed4aadfc50e45c26dd"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb9555182b4aa82f585d5307780039a9c60ac9496ef02fdae9a22fa06637e7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adb9555182b4aa82f585d5307780039a9c60ac9496ef02fdae9a22fa06637e7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adb9555182b4aa82f585d5307780039a9c60ac9496ef02fdae9a22fa06637e7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3164a53dc2963ad40b9aab79ad752a6c44aef00531d24fbe636b0273bf88302a"
    sha256 cellar: :any_skip_relocation, ventura:       "3164a53dc2963ad40b9aab79ad752a6c44aef00531d24fbe636b0273bf88302a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494dfde48bdbbf18e0a878311cac044d730cf6da03e1b983da650c3e298505c1"
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