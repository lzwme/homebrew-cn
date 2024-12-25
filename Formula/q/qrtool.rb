class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https:sorairolake.github.ioqrtoolbookindex.html"
  url "https:github.comsorairolakeqrtoolarchiverefstagsv0.11.6.tar.gz"
  sha256 "e5f67e3213950d7ac9bb467001a707fca6e1d786c707d08b4075966f2f3c7272"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https:github.comsorairolakeqrtool.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "281e05714eb6dd72bc306872b6b4c8f736bdd8afd927b99215390008d1865bcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b3f18982baf261832a00c3079e08f0eb10f647de3970ad86b49ff17a42e848f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dda14a0071a1b9352bca53678a7986ae30749223b74da6d51100509c69cb5a30"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ed5684aedf8af0dd4ff0aa2b91714133c52b34659143e6a25b01463dd85574"
    sha256 cellar: :any_skip_relocation, ventura:       "cb71c266c1539fea5d6b33c407b5b978045bee354846ec953daec72efcc2df44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87506857599b87007f4acd189e966c92195d4f36838caa079106f0b05d8bd21f"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"qrtool", "--generate-completion")

    outdir = Dir["targetreleasebuildqrtool-*out"].first
    man1.install Dir["#{outdir}*.1"]
  end

  test do
    (testpath"output.png").write shell_output("#{bin}qrtool encode 'QR code'")
    assert_predicate testpath"output.png", :exist?
    assert_equal "QR code", shell_output("#{bin}qrtool decode output.png")
  end
end