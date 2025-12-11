class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.54.tar.gz"
  sha256 "f54deadd6af77eb89d8d40e5e450e952d1239fe2aeb0da7941b93aa45536cda6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31f8433d5c0434cef546460710752a24a5e852503550712deddec647c897e465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31f8433d5c0434cef546460710752a24a5e852503550712deddec647c897e465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31f8433d5c0434cef546460710752a24a5e852503550712deddec647c897e465"
    sha256 cellar: :any_skip_relocation, sonoma:        "f96eb4ced65ddd9fbe831b39faea3d7886d2a1d39d101ea5be87f9940a58de33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a76629c7991f1c6a8fa8536daec7d1c891768768774cc67909cccb8a2f17a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82574beceb5a5e5124f4dd60a3bf586ef11b68859d21a0120f0d70b35d90e10c"
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