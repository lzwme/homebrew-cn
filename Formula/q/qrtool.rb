class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https:sorairolake.github.ioqrtool"
  url "https:github.comsorairolakeqrtoolarchiverefstagsv0.10.13.tar.gz"
  sha256 "924a4877789669f4b196b30738402cbae42c9664e32277a4c8a03b7b93212215"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https:github.comsorairolakeqrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63cc709c41a667d583e81fd109c4b0f154630a61ac58ca93877c06c9c4a70946"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf7ad6a5286d6051812ace0347a6db0257795cabb720d8a0f25afe08cfdf6b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8856558e01c62928258dabad66112117262ba2fe6b8a02c57414c0351e361063"
    sha256 cellar: :any_skip_relocation, sonoma:         "a76dd816e054bf73752eac12e274e6d43af280cf3d876e0aaeac60338b4dd45c"
    sha256 cellar: :any_skip_relocation, ventura:        "dd5f58f4a8282c6fc1206e2bccc33fc6b86be6dfc15a4157556d1fb1877619be"
    sha256 cellar: :any_skip_relocation, monterey:       "c5559e591c89f684d6eacfa8963023fbdaf96a58e2bc1ec8a4ff1f0698f74f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57be06c83f7279cb1b983e6c77cf6ea8ead35356d68fbc4a2179f64424959fa4"
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