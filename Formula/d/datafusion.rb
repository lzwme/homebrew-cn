class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https:arrow.apache.orgdatafusion"
  url "https:github.comapachearrow-datafusionarchiverefstags43.0.0.tar.gz"
  sha256 "a873124503ab5182dd3c00db52ed7bae29d09f72900442aaeff7854bfe8600fd"
  license "Apache-2.0"
  head "https:github.comapachearrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51818452ee82d9f0bf9f3a5d8c65de55a82f82080d6aacb6900059b8fb3b99b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18499f56ec85f8cbb05467b2c363e3437b1131f5e35709c83cea7805804159d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "614dbc21c07b982fb51caf29a09b3994a81cc9618c722c82cb6ba16483a703fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e61485922e624d4bba37e0b281f6ea7dfec83b127bf6a181bb3c10ea4939904b"
    sha256 cellar: :any_skip_relocation, ventura:       "3dce564739a041b3afddc7ef6f1c17a8d4487a79eb77f8d12de142324a7d0412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5f938d6ef13440075905b1d3a214667f75846a9e78a1ead4238f8f60e5a0a91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end