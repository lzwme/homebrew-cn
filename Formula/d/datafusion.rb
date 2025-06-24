class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https:arrow.apache.orgdatafusion"
  url "https:github.comapachedatafusionarchiverefstags48.0.0.tar.gz"
  sha256 "63f65035ccc7287a09f1ed0c7662f785986c5944fcce004d3bd728172273d4ca"
  license "Apache-2.0"
  head "https:github.comapachedatafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8399694f51eadeaa2a4874954584e4c89ef08c4680217b044eca277cf7f114fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cf55506373bdeae0a64bd7195236a5a1939e24f917e12525942bc1d0620097a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "797eca99d95ee6fbaf7561313ddac359a57f84d2187bde8d8c8bff786a588db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa49b534b3e770b6250eda074e6bd6c5ed72b1634a4d2a552495cf992f1e4fb"
    sha256 cellar: :any_skip_relocation, ventura:       "4720814dc8b84563d9e26649cfc30b27cadbb0e67bf2e503ca4f9e6e7f298feb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec13f6b06e96e616d330b818ce86220b0ac9119246d84a2cf258bb63111e8342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518e17161cf016860baa82318090f1cfe464fe15f9c2504de4e43d044aff3395"
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