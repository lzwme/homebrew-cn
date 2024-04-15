class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https:github.comokbobpspg"
  url "https:github.comokbobpspgarchiverefstags5.8.3.tar.gz"
  sha256 "eee68a38267fb4102b9cdcc3f5f27def799007f1ce71892e95111c27a05309c3"
  license "BSD-2-Clause"
  head "https:github.comokbobpspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28cf88251e378a4a2fb2fd318f93a27c80e37949a79d60fee96483b820144618"
    sha256 cellar: :any,                 arm64_ventura:  "86a1247dcd816c3bd544835ee100979a70ca786531f828effedb5ec086c00df5"
    sha256 cellar: :any,                 arm64_monterey: "2fda11d8b90811e0799ce62dea088568439dd98f4e2ad688d8133605ff038818"
    sha256 cellar: :any,                 sonoma:         "5ff52204beb6b4bcc0543684223cf4e78e2d9e880614c16965638ff0c8b0936f"
    sha256 cellar: :any,                 ventura:        "49d80ccd39f4347b1603ca34b573853979b9c901f69c0a5a2587859e2516b5d5"
    sha256 cellar: :any,                 monterey:       "b7b709129f39043d36201e2e3d9b3ce3bbece2356d48f05aaa3a472c1b202276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79bd557e540606181cc4e3ef31e26d9055eb1d81004f58bc1be47b16e789f0d8"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system ".configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}pspg --version")
  end
end