class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://codesnap-docs.netlify.app/"
  url "https://ghfast.top/https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "47a249efd507c0e1dcd8122da1d263b2bf00dcedfa27eed976a02909cefe0725"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06c1dafd27965b4e274ccfc36b2ee23d5f049be1a6ec6cb8cb4b4175db36a8d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "888e72eb89988d3f9db4467512eeb82762d33b41d9127a20de5a7e3111765a37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6620e43422a8bf5ef8679b765d25546375c433298799e0a878ec97a62f181590"
    sha256 cellar: :any,                 arm64_linux:       "6dcf6708d06fe819fe8def2cdf44cc5cfdf109bd6eb44359512387fa5685dd93"
    sha256 cellar: :any,                 x86_64_linux:      "f36bd8236c35f11f305596e300cbbf2012bb23c4c7c9d9443917f241319f70a4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")
    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end