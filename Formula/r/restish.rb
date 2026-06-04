class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://ghfast.top/https://github.com/rest-sh/restish/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "56234eb8442c2badacda10ebfe24fcac7a07e0125b7f741321f3004bd25bb52d"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51356c608790ad8456923c4d742d2c1957a82f94de35945bdaea2f927bf039a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51356c608790ad8456923c4d742d2c1957a82f94de35945bdaea2f927bf039a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51356c608790ad8456923c4d742d2c1957a82f94de35945bdaea2f927bf039a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fd81503bc242d558305ff9b671b3bc6fa637855edbea9b242eded0026b311c3"
    sha256 cellar: :any,                 arm64_linux:   "20588606ad8a58a96e201714f7faf6d5aa68d64ab9f109b1dbc637a66c83514c"
    sha256 cellar: :any,                 x86_64_linux:  "607b256eb6102031427eae150389297b84a45620c9ccea07ba6b0119f4e08630"
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