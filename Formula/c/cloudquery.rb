class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.17.3.tar.gz"
  sha256 "6fcd376a3db1ee8e92c459d0a0816ebd6c854a7f63553bb97add9f619b031d85"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed2ffcc109b10c1a15b9ec9bce4833b18e5a4fc156349f0cdc9ff93a0baf7e0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed2ffcc109b10c1a15b9ec9bce4833b18e5a4fc156349f0cdc9ff93a0baf7e0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed2ffcc109b10c1a15b9ec9bce4833b18e5a4fc156349f0cdc9ff93a0baf7e0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "24d1d4a0a023c3efe3909c024a4992745576a9ffc1ec890590c057acffe0a976"
    sha256 cellar: :any_skip_relocation, ventura:       "24d1d4a0a023c3efe3909c024a4992745576a9ffc1ec890590c057acffe0a976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93aa58dfccadf4c7752dca093e3df9c3da74969cdb6a7e9880dd35d9fb35ab21"
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