class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://ghfast.top/https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.74.tar.gz"
  sha256 "0ba110681f170ec421a6d7411fd7b20487fde77247b982fab58b2d2e7b1379d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb9fec73a315ff9a46bc47dedfd3e1f93358a40789a4ad3af934857afae78236"
    sha256 cellar: :any, arm64_sequoia: "dddeb6ec2028c2d20dfe112fc5a0148676a8f805073d2d902277ec52c4e850cf"
    sha256 cellar: :any, arm64_sonoma:  "1476bcce15dc8e554259a3943b29247fe6b451bed93c2f6ec595febbb479e78f"
    sha256 cellar: :any, sonoma:        "634fd5699f0f225a0809b4a3194d07eb5e34fcf8f8fd2ca49b092567a47af807"
    sha256 cellar: :any, arm64_linux:   "4e90ff5ce064bbc5f41c564dd08ff802957fed683cc2f4e67af842abdf6bcbd3"
    sha256 cellar: :any, x86_64_linux:  "08019bf950f3a9e1fa5c61a23b0808afc91332076729b52f3ab45e8e328fcb5d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end