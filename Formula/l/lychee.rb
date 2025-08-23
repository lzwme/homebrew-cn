class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://ghfast.top/https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.20.0.tar.gz"
  sha256 "defb37caebeddc0fdfa7205c0d69d58ed55fabb0cbfa5b48954b2442ec90c170"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74849d44f2825b328a9f756a78be4f46444e02e31a509639c20535298ce5a998"
    sha256 cellar: :any,                 arm64_sonoma:  "ce5f41b0515be3f4bd50362ee53c9dc9c6008186eb101ee1f2c7676beda8b056"
    sha256 cellar: :any,                 arm64_ventura: "a081d5f23d32426520078b318c9eab3482fe516d697d68ec0d806090bd7bc856"
    sha256 cellar: :any,                 sonoma:        "28a20434f97e647892ac0ce54c400990459c24c32142ae1134ae8497c643efe6"
    sha256 cellar: :any,                 ventura:       "c6945c6280f0739524b56175a8c6a6accfd41dca89bee959ce41f624bed7fb21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bc5dd89d340a19ad9291202fffab0d32d1cf9e746c3ce17565af768121b0346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74924a510b95704ff475af04b871010cd99c9030c5a2845c3d42a23353a6dddc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match "🔍 1 Total (in 0s) ✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end