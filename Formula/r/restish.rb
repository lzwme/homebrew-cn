class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://ghfast.top/https://github.com/rest-sh/restish/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "01788618eab038bc28f14329d2b177337d7284a82da09de2a47bae08e8eccc6a"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84c44010a36f59039cbe23d8dfaafdacea85992051b9ebb3fcf7f11af29054f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c44010a36f59039cbe23d8dfaafdacea85992051b9ebb3fcf7f11af29054f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84c44010a36f59039cbe23d8dfaafdacea85992051b9ebb3fcf7f11af29054f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e038f5a8debbe52ac9c16837220da4e18a28225e0c6c4d72d0e33a8c89bb074f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "327106ed2f639879f1dcaf08c0f90844bc7178f61e61cc18a19a2c48f07428e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9688a0ab831999346f636b82cbce1263cb0827cda302c1f27f968f4f66281d06"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for crypto11)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X github.com/rest-sh/restish/v2/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/restish"

    generate_completions_from_executable(bin/"restish", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/restish --version")

    output = shell_output("#{bin}/restish https://httpbin.org/json")
    assert_match "slideshow", output

    output = shell_output("#{bin}/restish https://httpbin.org/get?foo=bar")
    assert_match '"foo": "bar"', output
  end
end