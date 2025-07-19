class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.24.0.tar.gz"
  sha256 "88ebea61f0efd69c84e754fc44d6fdc1b8e50a8dd45c6a01233cff754b7da97c"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f459a0af57e5b61324a7235ec30ab58db335de21871a3ea5d94f58f8a182d7a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f459a0af57e5b61324a7235ec30ab58db335de21871a3ea5d94f58f8a182d7a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f459a0af57e5b61324a7235ec30ab58db335de21871a3ea5d94f58f8a182d7a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb10baa20287e6dc0de474062bffd205107cfd52d326fb314e3f257ede484b9e"
    sha256 cellar: :any_skip_relocation, ventura:       "fb10baa20287e6dc0de474062bffd205107cfd52d326fb314e3f257ede484b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a82d6fa4037b7fa81313f3e8a83ddbe9c512d2ea8b1f32c1c46514687e6206d"
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