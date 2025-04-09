class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https:github.comKSP-CKANCKAN"
  url "https:github.comKSP-CKANCKANreleasesdownloadv1.36.0ckan.exe"
  sha256 "4f0f2cf3a16d073ffddaeab68a61599b89fcf0d082a5e3d3a7276802862c1375"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c13567285bd77c9390aa195b9e323b21cabfdfecc58d212fb54aec8e5dbc684"
  end

  depends_on "mono"

  def install
    (libexec"bin").install "ckan.exe"
    (bin"ckan").write <<~SHELL
      #!binsh
      exec mono "#{libexec}binckan.exe" "$@"
    SHELL
  end

  def caveats
    <<~EOS
      To use the CKAN GUI, install the ckan-app cask.
    EOS
  end

  test do
    assert_match version.to_s, shell_output(bin"ckan version")

    output = shell_output(bin"ckan update", 1)
    assert_match "I don't know where a game instance is installed", output
  end
end