class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.12.5.tar.gz"
  sha256 "39d3f7a8a841ed61aadcc7e73c0886277c19111d4f1c51d8a376ed868d8b1685"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7650edd35131161c1ab6fe9f6566130e302dadcecfd4d1c6928f85c1d389a9e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7650edd35131161c1ab6fe9f6566130e302dadcecfd4d1c6928f85c1d389a9e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7650edd35131161c1ab6fe9f6566130e302dadcecfd4d1c6928f85c1d389a9e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b57e468947e17dd97f924f57cc501a39a4a2e316793ddcf539cc0f5ee578747c"
    sha256 cellar: :any_skip_relocation, ventura:       "b57e468947e17dd97f924f57cc501a39a4a2e316793ddcf539cc0f5ee578747c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d175b4e8b5b573732a4d536d5fab5d6a6193f44c5a1d1c618bc105e0c727cbe"
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