class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://ghfast.top/https://github.com/rest-sh/restish/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "28bb590d518c17ff51f6c07ad3cbbd417fb22a2cdbe122052f16b95cac652121"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d69d84b853907a489b0f752e18ab2f085a5b42c0f4f99cf1315d6ec8a89fdc54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d69d84b853907a489b0f752e18ab2f085a5b42c0f4f99cf1315d6ec8a89fdc54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d69d84b853907a489b0f752e18ab2f085a5b42c0f4f99cf1315d6ec8a89fdc54"
    sha256 cellar: :any_skip_relocation, sonoma:        "a067875c8eb3d2261a8edff96a940152c666947a59cff46d33f6a64bb07ad814"
    sha256 cellar: :any,                 arm64_linux:   "dbae26485591f33b979fdd90c2406d798fa62c50550e032bebaf41be24daf1a1"
    sha256 cellar: :any,                 x86_64_linux:  "55780bf798f6cacbe777bb7e1b381fea23d90a078cb4d8e5b6b24149d2f307d0"
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