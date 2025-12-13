class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://ghfast.top/https://github.com/rest-sh/restish/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "3686e652193c976a04c96f83ee1a78571509e22169b83f7212a7380b374d24b1"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6246d26482830c8cd5f803e924e809d4435c0f392d463d386b07175f69e9d84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2014864c672e3f861362294aa77e7f0dcacbff569a2347c550fa9f55677d15e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "376b8c14238c5cf3f095346d7f7a4b8378aad09288c2fbfe12bb1bbc42919550"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bbe15cbc23ce58c292823b9e4cd42a06673bdeb3aebe1c78534fac6c53df8a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f937623a0dfd7ec494f2f25dfa037c9899dfc9b3b341a394a3fcffed810d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12437fb2bf6d6c03963aab7f2a10dd861ec4f1d7ddd9258876b2e53d13612f93"
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