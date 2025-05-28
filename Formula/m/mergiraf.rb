class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.9.0.tar.gz"
  sha256 "52650dd6fd5908c7ef0989047577625f9a1002206bfdce8478ca893441c6c08e"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c241eb6f9636ad0acf5fe8c55a2c83684a5944c1b05430509e9d8f9cded1b7a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96ce9165a3bd22b9f68f505bfd04c2cfbb9b0ed66c96f1337152caf03497592"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34f5460361839a2918c55dfb2052a4cfebf8c9d96da371ddc243b6710f1e161d"
    sha256 cellar: :any_skip_relocation, sonoma:        "40360bf40a0adfd458f7b2c208d57309eb0ea2ceeb893f7d2921abc6070aafa7"
    sha256 cellar: :any_skip_relocation, ventura:       "5e390897f703ddbdc6c8aa34127f66b7a170f4cf026f4c66b39baafcd55c2743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fd9081da024b923b91e24b6db48b835cb0c6177d66e8e2413a87f90e424237d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd91c108b35fc815a60ff583e50afbee22cfb9e65617b6dbf8bbfc0397d8ee6"
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