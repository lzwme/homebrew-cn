class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.90.tar.gz"
  sha256 "dac2d06ed69d322a51b6eff25e11836cd783ce08673d83713745cb2621c56b11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff7d892bfae0323701e75551e4324a0b8d351317ae8c8e084d09977337cdfa57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff7d892bfae0323701e75551e4324a0b8d351317ae8c8e084d09977337cdfa57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff7d892bfae0323701e75551e4324a0b8d351317ae8c8e084d09977337cdfa57"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cd199cdbba37980f57fdce4018c70992833306e6682aac11468d1fed9e29c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7554bef087481421f6b78f7d2fd658e7d2b763dfd3829ec70c981b4516c1c97f"
    sha256 cellar: :any,                 x86_64_linux:  "447e83eb70332468bd10a47d7a329651835e48737880e0b55f60d8452e4a2daa"
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