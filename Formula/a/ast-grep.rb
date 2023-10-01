class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.12.2.tar.gz"
  sha256 "0cb0271124128f6060781db3278ff38e0ca10cdca9b3b649c7e822868dbaaf38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28cbfb4cdcca8d00e478c468ccab130d27ac22cc56222dfecb17ddfb134638b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f2a2359f09480870f4062407a5a309cd4e5956c429d2b6f9914f5526d76e29f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa20cdc2dbd99b85c072b84086744bf0e954617462f2ff5239c5949bae3cb66"
    sha256 cellar: :any_skip_relocation, sonoma:         "f198c8d2cf005e0ed33b9036acbdeea9314c98e13d1c9161a98b90de68cd6752"
    sha256 cellar: :any_skip_relocation, ventura:        "071eec884ed5a3a7312d62acb47b0036b51b0ed31de819e42124d4d547b7e12e"
    sha256 cellar: :any_skip_relocation, monterey:       "8473f908fba8ef2e917ed6b4533547ca6059b24a56e3a5c71b54e81f77735434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57dab4b76c37e0540885618d8254a8fce5b2a08e8aef0072f28274cd5c23ce43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end