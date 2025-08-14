class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "5e64a6ead47889e9f29814de47219521bddc0a49f251b3b981b18433472b04a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c35b4341155144db47cb7ccc157db867ec7f186a14560d0e34c108402103693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f366493fadd4019ca82178c7933f0de7cd02f1177a760efa184722fd6cc5fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a2e83d80bdebb32402667b22bc8b8f339f2994ee68b8f408f1812c0b4ada42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb0fbeff2496078a09da1bc1cd10ce772e39185cca1e0058c09088116b7b66b"
    sha256 cellar: :any_skip_relocation, ventura:       "f8af1e3fba627d519e5314851b83e289b787730ed2d35524fc6baf8385675980"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6904e7ac44434ab516edb5e74747f6ef40eb6576a46142810a8872254a0fa56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98d1616ca98be9b66260344376a5d04c30c49421c7354e19ed8c7c3a7dadfda"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end