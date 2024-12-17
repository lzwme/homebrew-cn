class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https:mesonbuild.com"
  url "https:github.commesonbuildmesonreleasesdownload1.6.1meson-1.6.1.tar.gz"
  sha256 "1eca49eb6c26d58bbee67fd3337d8ef557c0804e30a6d16bfdf269db997464de"
  license "Apache-2.0"
  head "https:github.commesonbuildmeson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb5d34c2d597284bf444ea8d00afaabbfcd1f8e067bfb34752c4842c9ce670ea"
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
    assert_predicate testpath"buildbuild.ninja", :exist?

    system bin"meson", "compile", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("buildhello").chomp
  end
end