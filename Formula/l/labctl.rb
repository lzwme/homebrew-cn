class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.96.tar.gz"
  sha256 "1400a0e136a5a5921766743b8d49a137720ee1ced0fba2e2d2b5c1977d58e503"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52d9073906108706705e45b954bfdbed103c0c4bcdb95b9a632db42a6b4dab08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52d9073906108706705e45b954bfdbed103c0c4bcdb95b9a632db42a6b4dab08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d9073906108706705e45b954bfdbed103c0c4bcdb95b9a632db42a6b4dab08"
    sha256 cellar: :any_skip_relocation, sonoma:        "0655f2a4a22041c2e7806e7a28708c1352626e255ea9042f118a9e0043a0172d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b7d398f0ab30dcfa4275f8e0c8b652a16671bf00f0bafae45f846b3ba66a501"
    sha256 cellar: :any,                 x86_64_linux:  "957dc7d7ef6a0d4a8ec620f4aa591424dfc12aa72d913a50ede84525e2ae491c"
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