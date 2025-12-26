class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://ghfast.top/https://github.com/mr-karan/doggo/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "d1bca6ecd8d245e940528b6dba645c5a2e5f6293a3901d5b9166834e0aff4da5"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04ed8b12923f3746f5b31fffc1066bc2df35a8e593a9450da18414509a9bc16b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04ed8b12923f3746f5b31fffc1066bc2df35a8e593a9450da18414509a9bc16b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ed8b12923f3746f5b31fffc1066bc2df35a8e593a9450da18414509a9bc16b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b26db6470789b2a22a6e2e059b55e3d23b05afa3ded87521ca2c3e5fa717ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "540ceaa283366547bdcacdac13e93a599464b56f79dc44c2220eb1dafafade71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb0555b6f8e7361987ab1fd5028a385d1bb21201e26d2db4c39a5741fc84349"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", shell_parameter_format: :cobra)
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "hera.ns.cloudflare.com.\nelliott.ns.cloudflare.com.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end