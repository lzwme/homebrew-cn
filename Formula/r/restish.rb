class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://ghfast.top/https://github.com/rest-sh/restish/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "ca8033595641c96d94c1c787550181ddb6f1a8333d7af5c24123a93ff75d0ff7"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "439dbb2c95722a2972905edc6db48bb3d06171a71903d12711df7f5c8b7ea4c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55e407444ad787069330bcc243643a92dcd8ad226fa48b6796b505a7cea4baed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e119336bc5a2da2193c8708cc21319e7d9bc7711fb75d322bf99534d405700b"
    sha256 cellar: :any_skip_relocation, sonoma:        "28034b5c1d654eb2669dc83f82a2ea9cd50d9624a04eeed550be9bb670db046b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3b3c62e044c3dc4fa342fdd7e893638f4eaa731b4559a5bb30714929b49cf60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "642bde791f7be3abe797b829754f5380ead9a3ba8458ae59845b19ea7a753ddd"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for crypto11)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"restish", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/restish --version")

    output = shell_output("#{bin}/restish https://httpbin.org/json")
    assert_match "slideshow", output

    output = shell_output("#{bin}/restish https://httpbin.org/get?foo=bar")
    assert_match "\"foo\": \"bar\"", output
  end
end