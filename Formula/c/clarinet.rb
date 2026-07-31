class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "355806adbd7a10af91753041a069fb1b741e8c594e7deda0cd250555353deede"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88b55a1244642c890478982f2884539feb6214be3c6778803c2b61f94f1b1626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31de4fd9d59f5889e279c6ed4be0557ae46c1c29e67b04368ccd45b7fb91cfb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a13db930369747b29ae5e6a30fa8ce07359214895ae0b69010c0249ac77e7b21"
    sha256 cellar: :any_skip_relocation, sonoma:        "4029469a473f8240e7a7cbfc45ca8b9d3afe5cada42b103bd91cf1d20bce5d34"
    sha256 cellar: :any,                 arm64_linux:   "3464e8b0b45740da837d0a1b44118610ac35c58538efa37d6d9a0aa54b8d1999"
    sha256 cellar: :any,                 x86_64_linux:  "04b9e97395207fc876188359a93d0cd0746d1b3430c3b3c2bf293eccdb85b13f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end