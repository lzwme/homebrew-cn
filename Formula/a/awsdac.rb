class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://ghfast.top/https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.22.tar.gz"
  sha256 "17c945bdf7d240f6419eff7cf02ed481c722904e2eaae927900908e50dc4d4bc"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b6981460ac521c51ca81dfe7a3f7e1bd96cd5b1b1245b89a6f4345c87c94f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b6981460ac521c51ca81dfe7a3f7e1bd96cd5b1b1245b89a6f4345c87c94f4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b6981460ac521c51ca81dfe7a3f7e1bd96cd5b1b1245b89a6f4345c87c94f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9c7230112af30cc31f606956cbd660757164e1257a44f46d5b12839226c62b9"
    sha256 cellar: :any_skip_relocation, ventura:       "b9c7230112af30cc31f606956cbd660757164e1257a44f46d5b12839226c62b9"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/awsdac"

    pkgshare.install "examples/alb-ec2.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awsdac --version")

    cp pkgshare/"alb-ec2.yaml", testpath/"test.yaml"
    expected = "[Completed] AWS infrastructure diagram generated: output.png"
    assert_equal expected, shell_output("#{bin}/awsdac test.yaml").strip
  end
end