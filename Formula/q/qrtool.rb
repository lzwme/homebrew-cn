class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/book/index.html"
  url "https://ghfast.top/https://github.com/sorairolake/qrtool/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "05f5c0abf7d312ed72a827426543969ca723d42068cd77e36e480cd670931893"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0e3f7ea317b79a6529ff508c6cbf0e49fbc56a58901b7eba927f6f215749b31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d10f224e95a98626a479a2c84b5e59d50bbd2e6dad787486194d1d5c814fb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bbd08bee21ec0c02b56086fa4fa927b799937d8dabf814647ec99119eebe03c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7ed1ea670fcd3bbbf7c854c79f13619d66420e36d29b2d9c0488909d53eab60"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec1283424b8d254662bba097d31c9d1b73afb7f004bb00ba7be365f1cfa50033"
    sha256 cellar: :any_skip_relocation, ventura:       "3bee8f7e1d5bee0b8699aaf084395f0f410743fc8e1b91abe28f4809512c0e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67bacd460faae54d71afcd4a1544eee9ac1715d4283730bc9bb6aabcbdc06884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5136be0cb03a9e0e2ff6b15cafa558f85ee23fc9d2d5066186bdc332560419e"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"qrtool", "completion", shells: [:bash, :zsh, :fish, :pwsh])

    outdir = Dir["target/release/build/qrtool-*/out"].first
    man1.install Dir["#{outdir}/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_path_exists testpath/"output.png"
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end