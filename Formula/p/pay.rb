class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.7.1.tar.gz"
  sha256 "8a6a703613325cea314faaa98c6051740302f49a0c0013400d6011d32920ca94"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a44be0f2d6e719ea03218d67e35c464b52154e9ca23a96b6fa0302a7afdecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644367f0a28f001666f169bc5569cdc2151f390fa555af773710a4470adf8402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a1b716e36989a89f9e134e68a6572daabc264ade27f0c3a5839d55bf75131e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3afd419e6ce113c2e0c3d2e66b3bd84d1b20b91e55692b9afb2a23c09414cb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e53186332e853a4ab99a4ce1cb610046a361d70dc5b41a137e270952fe44594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db7ce0bda09140ecc48afc58950cdac008be7d2b822e077dfdfb1b6bfb730af"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "no recognized payment protocol"
    assert_match expected, shell_output("#{bin}/pay --output=text fetch https://httpbin.org/status/402 2>&1")
  end
end