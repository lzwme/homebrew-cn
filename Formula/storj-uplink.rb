class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghproxy.com/https://github.com/storj/storj/archive/refs/tags/v1.71.2.tar.gz"
  sha256 "74e70f180c258f58c9e048d24e4e6a2ac4d71240d342d942ee6255cfe2827418"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2645db079a3998873e8f4f7d35b7f09da2e1e39ec7e4a340ece1f3202be5211c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76b2aabd5d1852c538e7608e0c64d5e3f95c7ec8d4f9dcfeb312ac89d8441ec7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3cd55494f5fe820cb36c6cbd120841927e07a9874ef61191e9d6b924645a0fe"
    sha256 cellar: :any_skip_relocation, ventura:        "a9062922cd377dda2542b87b0548cad2a1401f351d9f45654ebb0b8472f9a9f8"
    sha256 cellar: :any_skip_relocation, monterey:       "6a17e6d3576810c527e42874ca4804382a49af3d7ae048500a9092d4478e9d28"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b244a75c3348137316567c5d217fa1a739985c1c8af9fc24efa9841a660a6d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7750b031bb79718eaaa0cc839a356e7894314f88375cecf01975490f2d11b7c8"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/storj/storj/commit/873a2025307ef85a1ff2f6bab37513ce3a0e0b4c
  # Remove on next release.
  depends_on "go@1.19" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end