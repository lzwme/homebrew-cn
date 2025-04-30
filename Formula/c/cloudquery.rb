class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.18.1.tar.gz"
  sha256 "f874b83b18eabe7d864d1ec7d9717ebd6e62c790c8070068afcf2a2bac8803d3"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ab56e9ad075ff8167402cb0e6aaf32f32308bf06480433c0b3699bf68e387e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab56e9ad075ff8167402cb0e6aaf32f32308bf06480433c0b3699bf68e387e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ab56e9ad075ff8167402cb0e6aaf32f32308bf06480433c0b3699bf68e387e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "51170a51b5be3b66514288baa0b6820663f4317674d01962aff0150807dde116"
    sha256 cellar: :any_skip_relocation, ventura:       "51170a51b5be3b66514288baa0b6820663f4317674d01962aff0150807dde116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5da229fd8df2aff1556fde7923af1ce99aade3c933d9f75674e95741c5ef0bd0"
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