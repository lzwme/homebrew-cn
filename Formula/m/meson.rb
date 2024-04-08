class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https:mesonbuild.com"
  url "https:github.commesonbuildmesonreleasesdownload1.4.0meson-1.4.0.tar.gz"
  sha256 "8fd6630c25c27f1489a8a0392b311a60481a3c161aa699b330e25935b750138d"
  license "Apache-2.0"
  head "https:github.commesonbuildmeson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0754ab41a963c010173f20f5d8a13bb39078d3a26544aba20eb4071cc9914722"
  end

  depends_on "ninja"
  depends_on "python@3.12"

  def install
    python3 = "python3.12"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    bash_completion.install "datashell-completionsbashmeson"
    zsh_completion.install "datashell-completionszsh_meson"
    vim_plugin_dir = buildpath"datasyntax-highlightingvim"
    (share"vimvimfiles").install %w[ftdetect ftplugin indent syntax].map { |dir| vim_plugin_dirdir }

    # Make the bottles uniform. This also ensures meson checks `HOMEBREW_PREFIX`
    # for fulfilling dependencies rather than just `usrlocal`.
    mesonbuild = prefixLanguage::Python.site_packages(python3)"mesonbuild"
    inreplace_files = %w[
      coredata.py
      dependenciesboost.py
      dependenciescuda.py
      dependenciesqt.py
      scriptspython_info.py
      utilsuniversal.py
    ].map { |f| mesonbuildf }
    inreplace_files << (bash_completion"meson")

    # Passing `build.stable?` ensures a failed `inreplace` won't fail HEAD installs.
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX, build.stable?
  end

  test do
    (testpath"helloworld.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        puts("hi");
        return 0;
      }
    EOS
    (testpath"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    system bin"meson", "setup", "build"
    assert_predicate testpath"buildbuild.ninja", :exist?

    system bin"meson", "compile", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("buildhello").chomp
  end
end