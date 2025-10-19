class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://ghfast.top/https://github.com/microsoft/wassette/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "a93deb1f9f1eda822b7f204b0809080b650b090082eb0cef497368302379e68c"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbfebb93232b0f5f22dc73563a853dfac1ad05d99af58693e28a40b5208b2219"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e07208f45b50b6665cb5ae2c37a6edfd56a23843a9be781dbc83ea161c411b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef44182ef727db254e96583e1496fb5faedb1ed6b07912baee5c68b7c116cc3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c921d9f6a6e6e519e3702430275ca693586e3f08e342d948508f8cd2049d36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00e434208e2db978524e2ca91e7cc4bc84a111056d1b6dbdfe6e353d6ddbb28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df2f8ed17ab10ebf51fd4ab03e6f88c89cfd5ca55e0b554fcc38b434ddd9d276"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  # Version patch, remove in next release
  # PR ref: https://github.com/microsoft/wassette/pull/402
  patch do
    url "https://github.com/microsoft/wassette/commit/b71d3a26c568342dda5cca0ae502739dca2d1b95.patch?full_index=1"
    sha256 "87fb20240f450d7fb24f8ad8af43e340763865c42efa0cab27c7b8ed5b1b32b8"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end