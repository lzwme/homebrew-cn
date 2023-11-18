class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://ghproxy.com/https://github.com/01mf02/jaq/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3895dda6c808d93353bdcf3d265613c2c2fcdbbb20b1177bda8bb95fc0078277"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ac481e7515495075233fc390134ee45906beae2199225635150f82ea6025319"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f5fc74674a9e593c7f60c4bcbaf4b7472e693a5a213e6255bd99bee63e115c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae8a983c9181ea3d57435f7655e61bbfa0aacf6a186f22486fbe77f70ef204fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "eacaaee6a3e0a10a5c6d81250bc1bf53d649893ecb988da9973b6217cd745f7d"
    sha256 cellar: :any_skip_relocation, ventura:        "407a9909af3e23c0ab1d90180751bdd794a22f3e0939316c503110f16d739937"
    sha256 cellar: :any_skip_relocation, monterey:       "1410976e7d4cc452d6a003b1bdcde083880af4ba8fbc2f91c1729948244007ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166d578aad61147f8d4f4217ec64f1c2978057b93503c362fbc25efc616de44e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end