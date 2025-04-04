class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.17.4.tar.gz"
  sha256 "0be6af04de52fc8ff025bee853b1e74c580888f9c56c4cb97299d192b4118888"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4506862ca132b50f5b0d13c840d85adf48c2bb88f7006e74f10fd0b40b6ac985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4506862ca132b50f5b0d13c840d85adf48c2bb88f7006e74f10fd0b40b6ac985"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4506862ca132b50f5b0d13c840d85adf48c2bb88f7006e74f10fd0b40b6ac985"
    sha256 cellar: :any_skip_relocation, sonoma:        "a64ed2ea5707525293bb2a417f1e7ca07e29d8ef9bbda9c495c35b00243a99c5"
    sha256 cellar: :any_skip_relocation, ventura:       "a64ed2ea5707525293bb2a417f1e7ca07e29d8ef9bbda9c495c35b00243a99c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bba3d1c530618a77e0f7af27c8b28c74e0f384cee63a3aa86814a97df62533d"
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