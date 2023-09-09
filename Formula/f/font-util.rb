class FontUtil < Formula
  desc "X.Org: Font package creation/installation utilities"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/font/font-util-1.4.1.tar.xz"
  sha256 "5c9f64123c194b150fee89049991687386e6ff36ef2af7b80ba53efaf368cc95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f797dc497bc5e95e9e9840bdad4dde1c083f7c7f2bd26d577897f2bc63b27e6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ba2f844d8b9fcaaf5bd3c40d77e3e6f6d61306e430d87f5e2c6c9bc8238228"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa874f6feb2e9dbec27c1542c122fe4717397f0ee6f808048a5ed105b6870633"
    sha256 cellar: :any_skip_relocation, ventura:        "b6a7600ba11c04222874464dc5b7e01976f88f01f1fa4e33336c3bb5aa593aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "7463821e99f23ec109e6ea41d5c4a6bd79d6cbdbd8d52d58e727212c6fc215db"
    sha256 cellar: :any_skip_relocation, big_sur:        "48980593c214141ef4ad5c85e70104446df26b82689cf361128c740c1a48b8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deb3137c5cba7ee33ca8733cc79348b69bf8d337cb20037d12de3bf4eff593dd"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = std_configure_args + %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-fontrootdir=#{HOMEBREW_PREFIX}/share/fonts/X11
    ]

    system "./configure", *args
    system "make"
    system "make", "fontrootdir=#{share}/fonts/X11", "install"
  end

  def post_install
    dirs = %w[encodings 75dpi 100dpi misc]
    dirs.each do |d|
      mkdir_p share/"fonts/X11/#{d}"
    end
  end

  test do
    system "pkg-config", "--exists", "fontutil"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end