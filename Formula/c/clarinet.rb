class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "3dc203cb406eb3873f276efa98f4051d844dab5762bed2eb57d9bc44d53089ce"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "321cc64db986c8ee3c05432760d16551cc937bac501afa67a9f44877b7edbf42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87b7b3a26767f93617f9dd58fbc6a4d1e9617068e8a5ff3edb60c2b7986627b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "660ecdab8357520c7683e027a114b23787d8f16060016b995d6ebc0b1ae4b51c"
    sha256 cellar: :any,                 arm64_linux:       "dfe29109d3cb6cec316e1511ff12e5776fcbd8e2f00322a4746d3591aa9a2335"
    sha256 cellar: :any,                 x86_64_linux:      "ca4bd15ea625df09dc47e19b84b7c0b9ac0c736267a39110fa731e2533eaec57"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end