class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.24.tar.gz"
  sha256 "09daef029692926eb889001ae80415b74440a035589e7c950cd6ffc7ad3f7f82"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe1ec157b7ed0b2fc49afcc7858be6c8be13d19250bbe2f7209ca59147278434"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d03cb8bf5a9f9e024be155cb1480ba26c46ef136620a7c6bd569ac580268e925"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc49c45267701dee411961de1e9291c5d683a4a5251d85e9ee8fde8c345985e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd393fad070767e23a165ba8fd753c2a49096fdc2a906d7550246621ca7357ff"
    sha256 cellar: :any_skip_relocation, ventura:        "82383cf11a2ea02d087be7db10a4d74662b87b2e5f2f01c13f2d8cffbde313b3"
    sha256 cellar: :any_skip_relocation, monterey:       "24c44abc3dc595ab5ac1c6863cf5193126de3e95967872775b9da3d140c59ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa792c12b7b35880e33493a8ec84c17c054d53aa0ecb2354c68c66ea2362d40"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls -V")

    output = shell_output(bin"overtls -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end