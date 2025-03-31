class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https:github.comdustinkirklandbyobu"
  url "https:github.comdustinkirklandbyobuarchiverefstags6.13.tar.gz"
  sha256 "9690c629588e8f95d16b2461950d39934faaf8005dd2a283886d4e3bd6c86df6"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf3d8aef3bbd52b3dadb87d50cfb8962d46c1bef4381b9260e65b0783c2618fd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "newt"
  depends_on "tmux"

  on_macos do
    depends_on "coreutils"
    depends_on "gettext"
  end

  conflicts_with "ctail", because: "both install `ctail` binaries"

  def install
    cp ".debianchangelog", ".ChangeLog"
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *std_configure_args
    system "make", "install"

    byobu_python = Formula["newt"].deps
                                  .find { |d| d.name.match?(^python@\d\.\d+$) }
                                  .to_formula
                                  .libexec"binpython"

    lib.glob("byobuinclude*.py").each do |script|
      byobu_script = "byobu-#{script.basename(".py")}"

      libexec.install(binbyobu_script)
      (binbyobu_script).write_env_script(libexecbyobu_script, BYOBU_PYTHON: byobu_python)
    end
  end

  test do
    system bin"byobu-status"
    assert_match "open terminal failed", shell_output("#{bin}byobu-select-session 2>&1", 1)
  end
end