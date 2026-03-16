class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.63.tar.gz"
  sha256 "083a89080a47fc0c8d60bf4f0663e540b19e80f65dda997916401b6d0d30bdcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41010761e9855d0d3efb0cec79c8ee1e1c2065e3966e566fe7f6a068d375797b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41010761e9855d0d3efb0cec79c8ee1e1c2065e3966e566fe7f6a068d375797b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41010761e9855d0d3efb0cec79c8ee1e1c2065e3966e566fe7f6a068d375797b"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d4257ecf18973f448774c6b9dae1d08137410a017d83392bfe09a441238f5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b5b75e87cb15626f6a83113ba15f30370dc0ec8e0fde245afc188f2cdd65ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f57963ff5f6d9b588f9126b06ca3c1113cdb313c2056faf4f7703729c40ebab1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end