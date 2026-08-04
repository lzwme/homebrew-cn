class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.13.4.tar.gz"
  sha256 "8aad93ed29ca9e849f048b1c2b8e180c0823ead8249b550fd5f44fed63532674"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b9e8e2f2b41aad436a89e6c48fe633cbf7c54b80b1eddbc2ded5d1ac953b1f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "705bbfe56c2fc9bd4c7dde8dd70e26d92c482738db25aaeb414450d2a30d99f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a763a7e4fbe975eb583645f0b751e52919b37abf96cdb00c84d1f249e48a7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "48587d3990678ff1d34503f825a4406c2cad6b24dfa77f0913098b809262c7fc"
    sha256 cellar: :any,                 arm64_linux:   "1cf7900a13087212545945b0aeef12ca4eed216703b6ec0ed82f4eadde8567a3"
    sha256 cellar: :any,                 x86_64_linux:  "f6fea1ab63abbeb10ec808b1d14a5c2de4f86e4925a0111386c756d4d1db1c74"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end