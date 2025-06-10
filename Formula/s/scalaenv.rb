class Scalaenv < Formula
  desc "Command-line tool to manage Scala environments"
  homepage "https:github.comscalaenvscalaenv"
  url "https:github.comscalaenvscalaenvarchiverefstagsversion0.1.14.tar.gz"
  sha256 "82adc5edd81f1914fae321deea36123bc4d3a255e47afa857cbd8b093903530c"
  license "MIT"
  head "https:github.comscalaenvscalaenv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9587d95fe717240f70b2d0b7b1b90e17084bb635196e38e6bfc35be17a7cc7e3"
  end

  def install
    inreplace "libexecscalaenv", "usrlocal", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    %w[scalaenv-install scalaenv-uninstall scala-build].each do |cmd|
      bin.install_symlink "#{prefix}default-pluginsscala-installbin#{cmd}"
    end
  end

  def post_install
    var_lib = HOMEBREW_PREFIX"varlibscalaenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}#{dir}"
    end

    (var_lib"plugins").install_symlink "#{prefix}default-pluginsscala-install"
  end

  test do
    shell_output("eval \"$(#{bin}scalaenv init -)\" && scalaenv versions")
  end
end