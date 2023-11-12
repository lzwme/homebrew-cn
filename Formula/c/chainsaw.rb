class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https://github.com/WithSecureLabs/chainsaw"
  url "https://ghproxy.com/https://github.com/WithSecureLabs/chainsaw/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "bf342b986f402bd43a35429a5d5a00336957803260dbb2a3c5bcb6e263ee249a"
  license "GPL-3.0-only"
  head "https://github.com/WithSecureLabs/chainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbb75008ecda07b973c994a478bccb53713b856a18b74b4da5a88f1c6b4439b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b11d22c41c0ff927b1968ad5cb0371584303c830f61260abd8c87e3fae4ce4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "942def973aced78544244b5bfadf9a9b83b0c8a43459109a772114e4c49d0267"
    sha256 cellar: :any_skip_relocation, sonoma:         "41a31eaca764b286d329c9c290e60aefd22b407a93a31f126045722655188d48"
    sha256 cellar: :any_skip_relocation, ventura:        "e81176d842269f9f4ccf8df89459e5949854957903f981da240a5c40011f2550"
    sha256 cellar: :any_skip_relocation, monterey:       "045ebedff891af6eab11d72880b67a6f633f42f6481aa339e0d59639b13dddf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef955be9b4ba6bd53736c86e8ad7e824bf53ed4f80ad221d5fa04960fa78a8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}/chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}/chainsaw dump --json . 2>&1")
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}/chainsaw --version")
  end
end