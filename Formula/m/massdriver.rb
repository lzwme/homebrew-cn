class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.12.0.tar.gz"
  sha256 "3faf29ab7fc7f26b64daea520f7ab84eccc1e33f5674ff6a26446bd69faaeb87"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4acb110fd0ff56bc887ed31f755a2e9bdb776c53a769100831ec6c91d3ed9e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4acb110fd0ff56bc887ed31f755a2e9bdb776c53a769100831ec6c91d3ed9e49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4acb110fd0ff56bc887ed31f755a2e9bdb776c53a769100831ec6c91d3ed9e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "679e3fa24ec368e3472f27fe10a781ce70f14ea7b26ee420498e02bcaa02a1ee"
    sha256 cellar: :any_skip_relocation, ventura:       "679e3fa24ec368e3472f27fe10a781ce70f14ea7b26ee420498e02bcaa02a1ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "791ae203e52936fe501d64ea454f34d1ad50e6b668edcbe7cffc3b084e4a3818"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end