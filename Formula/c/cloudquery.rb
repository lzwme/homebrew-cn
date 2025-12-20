class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.33.0.tar.gz"
  sha256 "30720968d68cfab0983af0c8034213ac2d5fb0d4d91e8abd11fef23536005c39"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddee4a60c7fc7066894e00e371e11e18727f3d746f75a252730e74e543e94c4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddee4a60c7fc7066894e00e371e11e18727f3d746f75a252730e74e543e94c4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddee4a60c7fc7066894e00e371e11e18727f3d746f75a252730e74e543e94c4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dce13a51693f8a5c795c3ee14d1ee8927e6804e12ea0fd9944bc455f12d6b252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d9aae84c5808449edcd31abafea02a4fa6bdbb32fedefc7c81078f7b20bd81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b202cab62a694b4e174de6afec027e0babaf825beebaa35eed43292437dc7a36"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end