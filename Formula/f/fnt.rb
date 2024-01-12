class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOSlinux"
  homepage "https:github.comalexmyczkofnt"
  url "https:github.comalexmyczkofntarchiverefstags1.5.tar.gz"
  sha256 "f27271881858f35fc44802296c32d4b905c77f92171e8ac7593ffcc6e32a9ebb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b229a7fc67dd933e6651538c17a9b103877d1d2c396cc59b2657c147b1ed5884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b229a7fc67dd933e6651538c17a9b103877d1d2c396cc59b2657c147b1ed5884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b229a7fc67dd933e6651538c17a9b103877d1d2c396cc59b2657c147b1ed5884"
    sha256 cellar: :any_skip_relocation, sonoma:         "95687ee5860d1bdecaba8b81a981d3f6a57ee41fedb6f6a0266f6757a6e0cb07"
    sha256 cellar: :any_skip_relocation, ventura:        "95687ee5860d1bdecaba8b81a981d3f6a57ee41fedb6f6a0266f6757a6e0cb07"
    sha256 cellar: :any_skip_relocation, monterey:       "95687ee5860d1bdecaba8b81a981d3f6a57ee41fedb6f6a0266f6757a6e0cb07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b229a7fc67dd933e6651538c17a9b103877d1d2c396cc59b2657c147b1ed5884"
  end

  depends_on "chafa"
  depends_on "lcdf-typetools"
  depends_on "xz"

  def install
    bin.install "fnt"
    man1.install "fnt.1"
    zsh_completion.install "completions_fnt"
  end

  test do
    assert_match "Available Fonts", shell_output("#{bin}fnt info")
  end
end