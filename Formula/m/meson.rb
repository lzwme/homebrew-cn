class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https:mesonbuild.com"
  url "https:github.commesonbuildmesonreleasesdownload1.3.0meson-1.3.0.tar.gz"
  sha256 "4ba253ef60e454e23234696119cbafa082a0aead0bd3bbf6991295054795f5dc"
  license "Apache-2.0"
  head "https:github.commesonbuildmeson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66f902068e3039b66057e177944f57fe9e8343cbd14a2b22d0ae97362c656c7d"
  end

  depends_on "python-setuptools" => :build
  depends_on "ninja"
  depends_on "python@3.12"

  def install
    python = "python3.12"
    system python, *Language::Python.setup_install_args(prefix, python), "--install-data=#{prefix}"

    bash_completion.install "datashell-completionsbashmeson"
    zsh_completion.install "datashell-completionszsh_meson"
    vim_plugin_dir = buildpath"datasyntax-highlightingvim"
    (share"vimvimfiles").install %w[ftdetect ftplugin indent syntax].map { |dir| vim_plugin_dirdir }

    # Make the bottles uniform. This also ensures meson checks `HOMEBREW_PREFIX`
    # for fulfilling dependencies rather than just `usrlocal`.
    mesonbuild = prefixLanguage::Python.site_packages(python)"mesonbuild"
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
      main() {
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