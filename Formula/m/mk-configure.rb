class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https:github.comcheusovmk-configure"
  url "https:downloads.sourceforge.netprojectmk-configuremk-configuremk-configure-0.39.1mk-configure-0.39.1.tar.gz"
  sha256 "538cd03343c682db3684d5e850af4fc51db4e30a09a0be9a8b4a3b1a5dea83e5"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT", "MIT-CMU"]

  livecheck do
    url :stable
    regex(%r{url=.*?mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1d48910adfb8256bf27e0b61cda54ebcfeaad2ddfea80723bcd6669c9d4e301"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "724564cb4223251f86dbea709fed4ad7a8291c74aa12067963a51714e1cb4af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82cb821aa0e83c505083194f749d324d808f8c13267218b7995c0a906a4f3452"
    sha256 cellar: :any_skip_relocation, sonoma:         "efe67d40350feaaabb34a03f463ece17df5ea6916de3f1bda811e42f17ac487c"
    sha256 cellar: :any_skip_relocation, ventura:        "b40c28cffd685167b303aa172e3902923cfecc881627e1f5438b92b94ba6c46a"
    sha256 cellar: :any_skip_relocation, monterey:       "301e8943d383736b0e3238ac1598609078bdb8485766ed862149f482fdcdb3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "321711fd849d585b90d8fbd71f76e962129b625b23b760686a60a0e60e7e6942"
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentationpresentation.pdf"
  end

  test do
    system "#{bin}mkcmake", "-V", "MAKE_VERSION", "-f", "devnull"
  end
end