class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https:sorairolake.github.ioqrtool"
  url "https:github.comsorairolakeqrtoolarchiverefstagsv0.10.11.tar.gz"
  sha256 "9e3c65805045bbcc70a3106586b5246a6a7e84a2c1237bb957965c3d000836cb"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https:github.comsorairolakeqrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbb142962b6384952a3e8cf0c2650886e9fc2308e3832c88a58c7750a0931f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b643248a2e451fd2076b9e565dd6769e014b4cedaf6c34e295e9fe2684d1fd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082b11e2ccb441f98360698e997600314210b0b593f4730e9a4fa6474dcd8d82"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e2d7e692f8ea8853e1a32d68e967d5f9e089d113bc03a8d8c72239e239a72db"
    sha256 cellar: :any_skip_relocation, ventura:        "8b8630763a47b4f96c0766d2d3832aa9cf46214e381aa9b964f7bcfc995713eb"
    sha256 cellar: :any_skip_relocation, monterey:       "6c38d0bbcbe51637df7f3439b95d2ef539056362fbd82bd41a3dd9a02b1a255c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d562f0bd79e0eae800dfb504519bf339b74f9f58c3136567b513fe03ad59e4f3"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    outdir = Dir["targetreleasebuildqrtool-*out"].first
    man1.install Dir["#{outdir}*.1"]
  end

  test do
    (testpath"output.png").write shell_output("#{bin}qrtool encode 'QR code'")
    assert_predicate testpath"output.png", :exist?
    assert_equal "QR code", shell_output("#{bin}qrtool decode output.png")
  end
end