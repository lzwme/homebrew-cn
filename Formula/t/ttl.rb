class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://ghfast.top/https://github.com/lance0/ttl/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "a835db9d2fb03d5c84bbe91d002d6f7a9571bb21cef6911a26e38fd4126eb91a"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcba12d9c03a7e0420078a54032ec509ce8d59a7039a844dd1d6fed7968b0828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fa68fa8530bc15bab31b0407bae0f73c8bf7fdad080f372f51a34155a1d434c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd70d0a7dce8684e501fe8015dff3f1e75ad81fb655fb532df16ff76400f314"
    sha256 cellar: :any_skip_relocation, sonoma:        "15f185b0270b50336f14cf8d445a3aeb3520da00001aaf3e6fadc61ce8f93331"
    sha256 cellar: :any,                 arm64_linux:   "ee63cb89d2c04cfdcbf79fcef6743e52f121a731724117d510721ae91759e7a2"
    sha256 cellar: :any,                 x86_64_linux:  "a536708237307a6a019e63d6176d28d17472ae8507d0b2bbbf199de413aae2d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end