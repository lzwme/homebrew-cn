class Unison < Formula
  desc "File synchronization tool"
  homepage "https:www.cis.upenn.edu~bcpierceunison"
  url "https:github.combcpierce00unisonarchiverefstagsv2.53.6.tar.gz"
  sha256 "6cfaf0b3da5650933f8ff78668be3ebb316ca7b024cfb7905ccbd58e0fabe6fc"
  license "GPL-3.0-or-later"
  head "https:github.combcpierce00unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4418255bf1d68515665649051b123bfbb545aae4cdcbb0a03bb3b8efa91616f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0e5264991b7f1b718d91e0cac54e54655cbe1735ddb64f4f62de53923bd0d17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "795373fe498c75ead811eab897f9ccaa61cab76eafc0ad1d6f7c45cdb27210a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c32ac3d1116853452a4083c6e446b57f03b86ac4d3537655fd639f68df141096"
    sha256 cellar: :any_skip_relocation, ventura:       "20a4fe3b267d2eb481a7decb85dc4cb89b10b10b585d673f371e3aafbc861743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df04b1796c1779985cae3d527020223a94225f39f60cf8c84b839dfab26146ae"
  end

  depends_on "ocaml" => :build

  def install
    system "make", "srcunison"
    bin.install "srcunison"
    # unison-fsmonitor is built just for Linux targets
    if OS.linux?
      system "make", "srcunison-fsmonitor"
      bin.install "srcunison-fsmonitor"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}unison -version")
  end
end