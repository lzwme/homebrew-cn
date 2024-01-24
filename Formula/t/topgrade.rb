class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https:github.comtopgrade-rstopgrade"
  url "https:github.comtopgrade-rstopgradearchiverefstagsv14.0.0.tar.gz"
  sha256 "5635080f7b8d092c107b2b49a18b707a275bd07c6f121778d49b9d147eef9891"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "910072b01621d488ef2f653a30f686e48cd82abbf60b88e0e7c27982e9885211"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8603ccdab72c718e8afc1b8f06dd99a841e5f867bde11de22b15b8a96f0947b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1267c19a3831794f660289ad0e6695d8bf87c4ad90ae8b351781193db174b08a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d29bcf7bb6070a04f12b4727a46009ba57932c5f64cf770feee38a75ad39fd0"
    sha256 cellar: :any_skip_relocation, ventura:        "6d8b58b8c6b70c05e962765dfad4b8026d7758f02d1d9ed1e72fa15afcd66509"
    sha256 cellar: :any_skip_relocation, monterey:       "01691b9bbc9c6134221445a7d427a0b799be3ba381dfb9623ed0f7b256c7a986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab977bafff695ba0bd15ca3a1db59ed91182d49cdae8197db99cb648eb1482dd"
  end

  depends_on "rust" => :build

  # patch for terminal notification, remove in next release
  patch do
    url "https:github.comtopgrade-rstopgradecommitf794329913db5571a71e9ac8a36a44959d3f6a33.patch?full_index=1"
    sha256 "4b280f19c327e6eb9d86056c4f882234d4996b7429ad7f21c0b78d118f2d0a34"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}topgrade --version")

    output = shell_output("#{bin}topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}bin)?brew upgrade}o, output
    refute_match(\sSelf update\s, output)
  end
end