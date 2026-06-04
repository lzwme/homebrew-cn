class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://github.com/dustinkirkland/byobu"
  url "https://ghfast.top/https://github.com/dustinkirkland/byobu/archive/refs/tags/7.7.tar.gz"
  sha256 "7e278c86f9ae28f386c9b395871b2b50bcfb1e1540defefae740b7a48d10f34e"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "548b62adde75ec02ab5402a30b72917e06d0315e83215da3a90ed0d7bb56efa1"
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
    cp "./debian/changelog", "./ChangeLog"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize { system "make", "install" }

    byobu_python = Formula["newt"].deps
                                  .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                  .to_formula
                                  .libexec/"bin/python"

    lib.glob("byobu/include/*.py").each do |script|
      byobu_script = "byobu-#{script.basename(".py")}"

      libexec.install(bin/byobu_script)
      (bin/byobu_script).write_env_script(libexec/byobu_script, BYOBU_PYTHON: byobu_python)
    end
  end

  test do
    system bin/"byobu-status"
    assert_match "open terminal failed", shell_output("#{bin}/byobu-select-session 2>&1", 1)
  end
end