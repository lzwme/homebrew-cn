class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https:mesonbuild.com"
  url "https:github.commesonbuildmesonreleasesdownload1.8.1meson-1.8.1.tar.gz"
  sha256 "b4e3b80e8fa633555abf447a95a700aba1585419467b2710d5e5bf88df0a7011"
  license "Apache-2.0"
  head "https:github.commesonbuildmeson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6e7ffd7915e9e65e7e2b58c08a611615969e73ca6f4f1cc59d67c22baf850af"
  end

  depends_on "ninja"
  depends_on "python@3.13"

  def install
    python3 = "python3.13"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    bash_completion.install "datashell-completionsbashmeson"
    zsh_completion.install "datashell-completionszsh_meson"
    vim_plugin_dir = buildpath"datasyntax-highlightingvim"
    (share"vimvimfiles").install %w[ftdetect ftplugin indent syntax].map { |dir| vim_plugin_dirdir }

    # Make the bottles uniform. This also ensures meson checks `HOMEBREW_PREFIX`
    # for fulfilling dependencies rather than just `usrlocal`.
    mesonbuild = prefixLanguage::Python.site_packages(python3)"mesonbuild"
    usr_local_files = %w[
      compilersmixinsapple.py
      coredata.py
      dependenciesboost.py
      dependenciescuda.py
      dependenciesmisc.py
      dependenciesqt.py
      options.py
      scriptspython_info.py
      utilsuniversal.py
    ].map { |f| mesonbuildf }
    usr_local_files << (bash_completion"meson")

    # Passing `build.stable?` ensures a failed `inreplace` won't fail HEAD installs.
    inreplace usr_local_files, "usrlocal", HOMEBREW_PREFIX, audit_result: build.stable?

    opt_homebrew_files = %w[
      dependenciesboost.py
      dependenciesmisc.py
      compilersmixinsapple.py
    ].map { |f| mesonbuildf }
    inreplace opt_homebrew_files, "opthomebrew", HOMEBREW_PREFIX, audit_result: build.stable?

    # Ensure meson uses our `var` directory.
    inreplace mesonbuild"options.py", "'varlocal", "'#{var}", audit_result: build.stable?
  end

  test do
    (testpath"helloworld.c").write <<~C
      #include <stdio.h>
      int main(void) {
        puts("hi");
        return 0;
      }
    C
    (testpath"meson.build").write <<~MESON
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    MESON

    system bin"meson", "setup", "build"
    assert_path_exists testpath"buildbuild.ninja"

    system bin"meson", "compile", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("buildhello").chomp
  end
end