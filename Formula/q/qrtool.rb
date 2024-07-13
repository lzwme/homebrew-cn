class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https:sorairolake.github.ioqrtool"
  url "https:github.comsorairolakeqrtoolarchiverefstagsv0.11.2.tar.gz"
  sha256 "ed44888a3e43bd80c33d6e4af03b03fd210045c0f73b1452454ebe7d654f05a7"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https:github.comsorairolakeqrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86030efa23822a79047cdc83cd70da834f1a48267923eb14f562818ba024046c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "571055dbc6fba36d160f64fd9ea4b9734e3e01e8de91cdaf865999bc3b2db37f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f379940cf5b994a31f6c06028dec06dda4a0a5802621857f2d666ff04f48748c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2914f7c25079c79f526713bc6589df615e7a403c80d4e59ce2054844ed994555"
    sha256 cellar: :any_skip_relocation, ventura:        "82caf99213c2aee80784d21e22e335d1b9796d69f82566f9f63dd482d20a0b92"
    sha256 cellar: :any_skip_relocation, monterey:       "649d72e3e53dab939b9e02db5b3226bc4dc4461de5a317e4277a389cdf10b996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77a03b4937d9e0ad5922bb5454e05cff9326d26dc17121e7fd9a186194794f55"
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