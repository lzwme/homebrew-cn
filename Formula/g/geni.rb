class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.0.12.tar.gz"
  sha256 "1dc41d7eb599bf9bfb583239ecc99c93e90fad2b3a0fad968de6f2243d08b48f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "288791c3f091a23c545498bac799e12c012c9bbd120072d0c534c896a21ba572"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c4f6d2535cd19da121b077c38ca9d3fdd32c395f9029d18f853ccf71f4a0b7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2995f45b8c7b1557f1c2ae87424c0507570bf0342ec375fb78d062789935d638"
    sha256 cellar: :any_skip_relocation, sonoma:         "49af7c0704657ab750e25602289deec167742c1e724298ce0c0a6e95f33cf10b"
    sha256 cellar: :any_skip_relocation, ventura:        "6fcdadcfecc05707d569635fc968c40b70a88536cd9a6b21aef02ec6f8b411fa"
    sha256 cellar: :any_skip_relocation, monterey:       "00866a8f4f3ef1db70d38ce9edcd58d376590159656084e4fe4f502dad8a85e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7846ad610ba00259775fcc4a2f23bf37a2f7a626dc2b9eab81b3e2965f903ec9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3:test.sqlite"
    system bin"geni", "create"
    assert_predicate testpath"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}geni --version")
  end
end