class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://ghfast.top/https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.08.25.1.tar.gz"
  sha256 "faefec2195d1edaace0b2f81769ace6ba68444472d06c6d2d796e56ec23cdadc"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e43ffb2f552d1f1d7e69d4029d3ca2113fc0adf68e7af55bf8cdfd7b44daab3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e43ffb2f552d1f1d7e69d4029d3ca2113fc0adf68e7af55bf8cdfd7b44daab3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e43ffb2f552d1f1d7e69d4029d3ca2113fc0adf68e7af55bf8cdfd7b44daab3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6e944d359de9aa09f113ed97423ec84d593ed2dccea21daac09b54178fd774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "597edb685ebed6061836fa3a619fc144974b065db02fd48d9f14a2472f187729"
    sha256 cellar: :any,                 x86_64_linux:  "fa5197122f8735771c27344b60885dad26714907e0ac6c3e840e87ee3f564f66"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/scrutineer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrutineer version")

    output = shell_output("#{bin}/scrutineer -runtime brew 2>&1", 1)
    assert_match "runtime: must be \\\"docker\\\", \\\"podman\\\", or \\\"apple\\\"", output
  end
end