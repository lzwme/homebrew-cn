class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://ghfast.top/https://github.com/humanlogio/humanlog/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "7afa710836c0160ec592ad991bd2f578bd6e8546780604e844810b214a877bc7"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3917ce71ad578fc5d249633a98f7390d7be1443c3c97dc8e12c4745c07de69d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66098b4611b1c1db81a9dd34927ed0275d79c96b373b51b7fe91339c467dc535"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99fec3786cf3ad4383bad07a7646db9910957243488d143ddea96a4f8e01be7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "021d5abbd55a2c463908c204bd46e85a4848024b36e6b68dd3b393d0595b90b3"
    sha256 cellar: :any_skip_relocation, ventura:       "06e93fb13fe39a5ef8507f7c1aff3fb9ecccecfbd14f68d6b96eabee4c61f0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c241f1ea6634a95bd4ca6ba8b52d00c8d48fa732b70bef908ec7f8671df5fb7f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionMajor=#{version.major}
      -X main.versionMinor=#{version.minor}
      -X main.versionPatch=#{version.patch}
      -X main.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/humanlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/humanlog --version")

    test_input = '{"time":"2024-12-23T12:34:56Z","level":"info","message":"brewtest log"}'
    expected_output = "brewtest log"

    output = pipe_output(bin/"humanlog", test_input)
    assert_match expected_output, output
  end
end