class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "20107913a64ee434c3c946ea72cee7b05d87b06b2ef304432c20e7c854bfab94"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f70e95074fb8d6afc7e78e7bf13e28377d3528feaffef2daae6a89c5408e294f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aed6464edce8c5918cd44f475b0c7bc7f15ed5ae21dccfef578cd997a09e0f2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d413e97d45d7e150834da6ee0ce4c97daa6693596623886a976dbc636e945b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d14ae020fad882db3895eee342e790af7354a1691fd9bbc92bdddd102192cfe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b9f31deefa61dbf9953aec5125eda10100ea0f617c086e92be6c6ffb4b334cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85a26166b08ee4302b757ceea439bc995f10bccd7f5fcb89c9818e6088fb9052"
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