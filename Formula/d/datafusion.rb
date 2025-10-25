class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghfast.top/https://github.com/apache/datafusion/archive/refs/tags/50.3.0.tar.gz"
  sha256 "0dfef181973c89bc645497c141409102ab627ed7137e99b020d0c4efd6ed9c4b"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff863741789a18995d581582708f784a449e5f264d439482e00345b2f1beefc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4876d1442e1389ef07c8289737685a191df5b21758f20dd78403c638725b8c3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "644c938cb324e08336183883225f02419960426152fee747717635bfa01bf2aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4c71efe8d9e4283be8b3be210c99e41f1e6070c5998e9c5aca03f040aed6dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bc0f4394b2798117f502735d8eefb5fcaaa32c47004780a00ca5893b7ff21a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63f4fc2d4950f5247c1f7c459b0e124f7d7dddb754e6107282c300935ee71006"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end