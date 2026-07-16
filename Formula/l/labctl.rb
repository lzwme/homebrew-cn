class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.99.tar.gz"
  sha256 "4d5caf5a3ff365822a64a5db026acc124370045663521e7c8a94ec846cd984c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "864a217fbf4cd659a6754772ad19ff05a1297b49c0f002fafc0cd8633a5e10ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "864a217fbf4cd659a6754772ad19ff05a1297b49c0f002fafc0cd8633a5e10ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "864a217fbf4cd659a6754772ad19ff05a1297b49c0f002fafc0cd8633a5e10ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "52b7405ee1ad6a8b2cc12fe805e89e9fc6017e42cbbf9100714af7f7ab55c202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b111244810c75da93d0ea5b8d1bede36669761476ca2dcd657d1a7aca211f2db"
    sha256 cellar: :any,                 x86_64_linux:  "51e6d91e14a75245e48bb4885f8ec09a2b26c3422663f08f2340a9ff1ca5085a"
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