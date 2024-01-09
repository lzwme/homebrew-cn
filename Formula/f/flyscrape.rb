class Flyscrape < Formula
  desc "Standalone and scriptable web scraper"
  homepage "https:flyscrape.com"
  url "https:github.comphilipptaflyscrapearchiverefstagsv0.6.1.tar.gz"
  sha256 "4480c597688d63bd3a4601801f7a056f9e0723bbad199a9e52573cc7893fea85"
  license "MPL-2.0"
  head "https:github.comphilipptaflyscrape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4e5140a1164a152a1a461d29abcf917f88e8ca4d9cc466003025dac89354e21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7accb464b34a73d34dec891b298804859cfd4d12436f289b5315c8109b15aac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beaa1f05ef26f10b337913db24531b91c065d652c1618d2b2dedf43115703687"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd4ca616f8e9d2f391815d412e71a70c686c4fbad7869918877f83f231628227"
    sha256 cellar: :any_skip_relocation, ventura:        "06304c3c96b25d680145c025b67a0cd2f0d414049785b38506c15f2e39b243ae"
    sha256 cellar: :any_skip_relocation, monterey:       "30328ed449a3415ff54d1a428dd4f656a018ab378d4d4ef75435d650c7a6e4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338d715deb73cfb72e4d8c3d1a8a4d6f6809a91a01ce44ec8b3df96efd7826d1"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  def install
    tags = "osusergo,netgo,sqlite_omit_load_extension"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", tags, ".cmdflyscrape"

    pkgshare.install "examples"
  end

  test do
    test_config = pkgshare"exampleshackernews.js"
    return_status = OS.mac? ? 1 : 0
    output = shell_output("#{bin}flyscrape run #{test_config} 2>&1", return_status)
    expected = if OS.mac?
      "unable to open database file"
    else
      "\"url\": \"https:news.ycombinator.com\""
    end
    assert_match expected, output
  end
end