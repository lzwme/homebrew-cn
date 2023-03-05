class Wtf < Formula
  desc "Translate common Internet acronyms"
  homepage "https://sourceforge.net/projects/bsdwtf/"
  url "https://downloads.sourceforge.net/project/bsdwtf/wtf-20230303.tar.gz"
  sha256 "7188c8baabd83d28bed484b17d19c9d9a3aca4b11140247dc7df18263587bd3d"
  license :public_domain

  livecheck do
    url :stable
    regex(%r{url=.*?/wtf[._-]v?(\d{6,8})\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c3b9661681fdb09524fed656100d2cf8b900cf9985a96e898543652e29453cd"
  end

  def install
    inreplace %w[wtf wtf.6], "/usr/share", share
    bin.install "wtf"
    man6.install "wtf.6"
    (share+"misc").install %w[acronyms acronyms.comp]
    (share+"misc").install "acronyms-o.real" => "acronyms-o"
  end

  test do
    assert_match "where's the food", shell_output("#{bin}/wtf wtf")
  end
end