class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://ghfast.top/https://github.com/openpubkey/opkssh/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8911e9d226d3253458707b03656d8478acad9b614272e65ed51f3cd548eedc2a"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920dd50c96254f9ae687f043ddfc6c72762ca9d2806d691194fb37a4a5bc1d20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920dd50c96254f9ae687f043ddfc6c72762ca9d2806d691194fb37a4a5bc1d20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "920dd50c96254f9ae687f043ddfc6c72762ca9d2806d691194fb37a4a5bc1d20"
    sha256 cellar: :any_skip_relocation, sonoma:        "60366b51ffb3113ba4de054ed65096fc084982b857518d36ef186fb72ebb0c87"
    sha256 cellar: :any_skip_relocation, ventura:       "60366b51ffb3113ba4de054ed65096fc084982b857518d36ef186fb72ebb0c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95139838cd79b48ada9cd27f2c785cd45b5b3833cbc0267e9cd1681c37851528"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end