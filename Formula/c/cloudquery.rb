class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.15.3.tar.gz"
  sha256 "d47b445db1c7de96640a0be28a832c086f6a21b3e6949a7712bd9bda3a5d52ec"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af63cfd7a676b7ffb0e43f87c19d60cc3438325a419f7783673bef579379e7e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af63cfd7a676b7ffb0e43f87c19d60cc3438325a419f7783673bef579379e7e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af63cfd7a676b7ffb0e43f87c19d60cc3438325a419f7783673bef579379e7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1746b509e9a2bee6dcbc0e88781596174124f846209f3cb45fb57c0bfc23f93"
    sha256 cellar: :any_skip_relocation, ventura:       "a1746b509e9a2bee6dcbc0e88781596174124f846209f3cb45fb57c0bfc23f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb64a4224a355e9a16b8348a7a3a742dad61a9776673d1b13271bcdd62f2c6ba"
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