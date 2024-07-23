class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https:sorairolake.github.ioqrtool"
  url "https:github.comsorairolakeqrtoolarchiverefstagsv0.11.3.tar.gz"
  sha256 "e7ec7e93af7a2ccae2cc5c98454e07b62bc54a590c788837764a68561da65b5e"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https:github.comsorairolakeqrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "914aa81a5d899072c4c61552f9d985fd1100b4133e87cf602c736eebcb9da095"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e30ac5b5c350be553d7d9bc62c591a6ec6d2fbe9580b3b649a399ffffa91a19f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fcbed72ec9aea3fab608726adfbd65457253f5b4cea4ab43ff0588e47fd1614"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dc2b232fa5273686f24d0d836bf8b99a3feb50e1a195411104030b9bb184cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "70f284055f5c2319d183e98bca89d0f21440c75c947dc7305fcc293bca08be59"
    sha256 cellar: :any_skip_relocation, monterey:       "583d3d16e621172d83f47ce12b18951120ffa04361c635913584d92e36427bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c80b817a888ad5b8883a58e5eb5ce062bde5b08677162481fe5c580a0b2d0ca2"
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