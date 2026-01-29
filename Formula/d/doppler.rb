class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://ghfast.top/https://github.com/DopplerHQ/cli/archive/refs/tags/3.75.2.tar.gz"
  sha256 "3c6e1c99fae29345d6c7266414dacc7232662df9739d9db5d3ea64d281d23c19"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc7486e530ab4bab53c57b03b6008d6cd03d4fe110d5633013444e05cba6e2d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc7486e530ab4bab53c57b03b6008d6cd03d4fe110d5633013444e05cba6e2d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc7486e530ab4bab53c57b03b6008d6cd03d4fe110d5633013444e05cba6e2d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "549b8e3f8bde50bb9dcbbc4faa4feecac2ba70f816664131c896ca06c3a87c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6145e53244695140b600e6802cd0a7154735f214849041e01ed7fa847eea2feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffa803ed60ec8975265a8f36b8b7ff50df1a39a6ce387b5c14f89763ad179be2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end