class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https:github.comRubyMetricchsrc"
  url "https:github.comRubyMetricchsrcarchiverefstagsv0.1.8.1.tar.gz"
  sha256 "864845beaec2a94ce8a6d43503a02546a403a27df0982846564ec6ad88b8bb67"
  license "GPL-3.0-or-later"
  head "https:github.comRubyMetricchsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f2903a7bb3f52979ab4ac9780e5d6ec76607bc71b7fbc981e3d784f52e0baa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce5fdd601a103b6aa219b1d441aff9a9b0b535760ae70f066d615e0c86d7ad2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba73897e54c00309f3a1cc6d1787709805475c1304f6641e6499093eb2200d07"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1e53e4084a525e46abb477b8a2320926750127f40c1e1f118dde9918d611672"
    sha256 cellar: :any_skip_relocation, ventura:        "755ffc6880ee43da9afbfb04e837193eac028e27cc694e690e6fe2f695ba130a"
    sha256 cellar: :any_skip_relocation, monterey:       "0745b821775954ed292e89da9f5a83aa662f48515efcb73277dd7d3e02f2b28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d557ab6b92d0b82730b4c43e89844ad947b0ed9cb38321ebe945632b33bc42c6"
  end

  def install
    system "make"
    bin.install "chsrc"
  end

  test do
    assert_match(mirrorz\s*MirrorZ.*MirrorZ, shell_output("#{bin}chsrc list"))
    assert_match version.to_s, shell_output("#{bin}chsrc --version")
  end
end