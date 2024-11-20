class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.3.1.tar.gz"
  sha256 "e43643068d3e80520e64893090cdde7ce8d8e1a7325969802f1f5f8165465845"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19805e9e269c29d9e9db3f8b2a418b44a513e1d8cdc618935f25427883d3c79f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "610f65b18b12ddff9b8ea70af9efdb4c770403cb5bcd845dd21830f6df6a51dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91b6ab8a00e6a525ea130851d3cd8271b06d7cb0b854c3c49afbb04076fb4642"
    sha256 cellar: :any_skip_relocation, sonoma:        "89874bb76c4e67d6f5ec78000294ce6fc22c57970129c2cc7d090e734b5323b4"
    sha256 cellar: :any_skip_relocation, ventura:       "b21a4ea805e1216f2c64ef283289e9ad99217d288b30f4b02cf527fb3f9386f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16db04cbfd5c7210509389eb632d7e3818c93e24816fbac201077023abfef114"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end