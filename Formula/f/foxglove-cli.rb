class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://ghfast.top/https://github.com/foxglove/foxglove-cli/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "5cd9729fdc440a77471400de4fb327d9bc9aaaab3f01ea7d18b5012ed3075ee7"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fabede3a42b576c1b49ba736119ad1d1e0d69df2833c87ed87130e6dcb56268a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d2097ea7ec57f3ec3e78c96c452b1da5168a1dc96ec07d6e931116245c5184c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1866c857801f4d81537e2b91adb01dc1c41dd456bc727fe3399c42a0e509968"
    sha256 cellar: :any,                 arm64_linux:       "98b79acccc066c8165f08b5ef3d5da515e601ad75f7931514e77a2ce9ba1eac1"
    sha256 cellar: :any,                 x86_64_linux:      "02d3201bdf03952299cc6898d2628ffa0568e13a832c5e84de76e772f26beb9c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    ENV["FOXGLOVE_VERSION"] = version.to_s
    cd "rust" do
      system "cargo", "install", *std_cargo_args
    end
    mv bin/"foxglove-rust", bin/"foxglove"
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end