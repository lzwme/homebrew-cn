class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.8.0.tar.gz"
  sha256 "77a7e27c317a60b6babd3fad426b8db648887cc2d48e59dbc62ef1484f673105"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e34612a680493ba907fa4a2cfc3b9999ce9791985c9f6426bab235e50d2fff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e260505c1c1b17533e87550004026f3bf6cc28edb554d42166c32311ab43297a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6ecc221c9a95265df64bd1d577091db78ac579b5e53d9ef5f384d70a8502c3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "df251f754c964da92d4d5b8bb453bf18e5da71780ffea6b82cbd4ee53290bb5f"
    sha256 cellar: :any_skip_relocation, ventura:       "429c2fdc52a580d90b62698b5f07d000afdee4d9f46ec47f8dac3a5df3455829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9deae7208ea102a840e63e50b04ed3cf80d60b289ac9e7c8bf4d145bc9960c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef53a28bf831e9e7d0c0889879010332c814e3ccad29fb4e646dafce77ea620"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end