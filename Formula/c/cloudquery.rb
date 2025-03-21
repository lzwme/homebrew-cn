class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https:www.cloudquery.io"
  url "https:github.comcloudquerycloudqueryarchiverefstagscli-v6.16.0.tar.gz"
  sha256 "49a7a48b2e040444763f4e2e470979b22581c40da04d0405750386f4b05bb144"
  license "MPL-2.0"
  head "https:github.comcloudquerycloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(^cli-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af1ff6ccb6229a079e00b624a45ae50cee8f30ca05e28a6bf2637c7bf9746dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af1ff6ccb6229a079e00b624a45ae50cee8f30ca05e28a6bf2637c7bf9746dea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af1ff6ccb6229a079e00b624a45ae50cee8f30ca05e28a6bf2637c7bf9746dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "394617d38e678e838eadfec996c349361c5490a2f405970f363c371ae8adb688"
    sha256 cellar: :any_skip_relocation, ventura:       "394617d38e678e838eadfec996c349361c5490a2f405970f363c371ae8adb688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb1ddc378d3de2a7d3a453e4c4181b11ab108b8488012c1d50003f3d406fb32"
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