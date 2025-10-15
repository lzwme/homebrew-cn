class SlothCli < Formula
  desc "Prometheus SLO generator"
  homepage "https://sloth.dev/"
  url "https://ghfast.top/https://github.com/slok/sloth/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0ab75ec4b1c3a63acf3dd9369e963dddb92aa4cab5ffb327ccc5901e1d41dfc7"
  license "Apache-2.0"
  head "https://github.com/slok/sloth.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd13f096d2a93695170735f735ffb14d76833d573785a50d967a7683650db6fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8873f320aa92648e31f022a309e51f4f55499d073f066394438c99db045cd47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c77956edd41641502a6b811468fbe94c217031f2e515470e3ac35c98202b2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8444568750d4b683f5f7ee2ceff5ec5d75e9f7012b9af838fa9700ca018993a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b12233d1e4a365210e790554318f0e2f9b254cd08f83e184f59f1120063df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d368278d33886db632db9c4baa423994c86337390d05bff49063c3c142bd6301"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/slok/sloth/internal/info.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"sloth", ldflags:), "./cmd/sloth"

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare/"examples/getting-started.yml"

    output = shell_output("#{bin}/sloth validate -i #{test_file} 2>&1")
    assert_match "Validation succeeded", output

    output = shell_output("#{bin}/sloth generate -i #{test_file} 2>&1")
    assert_match "Plugins loaded", output

    assert_match version.to_s, shell_output("#{bin}/sloth version")
  end
end