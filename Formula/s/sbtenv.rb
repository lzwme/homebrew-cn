class Sbtenv < Formula
  desc "Command-line tool for managing sbt environments"
  homepage "https:github.comsbtenvsbtenv"
  url "https:github.comsbtenvsbtenvarchiverefstagsversion0.0.24.tar.gz"
  sha256 "f483769e5467c718c9de72baa4eb3c679315e4f4a9ac02bb636996a63c28e3d5"
  license "MIT"
  head "https:github.comsbtenvsbtenv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6e5520ead3c64eb3f68e1bbc7e54ee271aaf36b1bc2b442b9514269df90a7047"
  end

  def install
    inreplace "libexecsbtenv", "usrlocal", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    %w[sbtenv-install].each do |cmd|
      bin.install_symlink "#{prefix}default-pluginssbt-installbin#{cmd}"
    end
  end

  def post_install
    var_lib = HOMEBREW_PREFIX"varlibsbtenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}#{dir}"
    end

    (var_lib"plugins").install_symlink "#{prefix}default-pluginssbt-install"
  end

  test do
    shell_output("eval \"$(#{bin}sbtenv init -)\" && sbtenv versions")
  end
end