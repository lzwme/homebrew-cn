class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.38.tar.gz"
  sha256 "8a4fbb75bab424a85c75f62f13a59e1eb5a62687921d8afbf11bde1a71eb7eb3"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "419a33ead5191dac369ac3c67ba9607509b1d45e144b990c7bbbf9d18a712b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b66ec24c8698bc3a044ce3f8cad90901f17b54be1b3d6b704d12449b372c170"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dbb28177239803b6ad7dd434453cd7518bc60c56804e64fec7f6456e4f4f953"
    sha256 cellar: :any_skip_relocation, sonoma:         "378d073dd16768dbb749194ffbef950a861e89817e40321b3b2cc058cc0f382e"
    sha256 cellar: :any_skip_relocation, ventura:        "7341816d3e92b76054e77fedae06a9aacd0a3eb0b39f77aa36932eb660d13474"
    sha256 cellar: :any_skip_relocation, monterey:       "3d9103547c9f10351e95dc003e896d03336d187a1cb39e3bcff94a22ddceec1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "675c5ef4f559e2445abb896f6acf0dff17e6e84c2096a1779a18cd58d3afe722"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end