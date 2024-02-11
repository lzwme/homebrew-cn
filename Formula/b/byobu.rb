class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https:github.comdustinkirklandbyobu"
  url "https:github.comdustinkirklandbyobuarchiverefstags6.11.tar.gz"
  sha256 "3d11b7facfb90c69446504aea6f3e91af7483074a39df9931415e5d92bcc330c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fb1a40a8d43c7f976839f13db84a25dc1e9c98bec350a6db6018693bb22c048"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "newt"
  depends_on "tmux"

  on_macos do
    depends_on "coreutils"
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