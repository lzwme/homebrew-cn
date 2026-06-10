class UutilsFindutils < Formula
  desc "Cross-platform Rust rewrite of the GNU findutils"
  homepage "https://uutils.github.io/findutils/"
  url "https://ghfast.top/https://github.com/uutils/findutils/archive/refs/tags/0.9.0.tar.gz"
  sha256 "8b3eb813cac9fe519b77ee36705fdcd46b188d8807e98c0bb7126fabd8f64dda"
  license "MIT"
  head "https://github.com/uutils/findutils.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2177bb345ea17795a16743aa6e4687cd236647b7e6cc8bd6d2286a95091e1e47"
    sha256 cellar: :any, arm64_sequoia: "c63585b24856bd7f886b76161c16e9f61ad0f62100e965dad1d71f5ad19e533b"
    sha256 cellar: :any, arm64_sonoma:  "4626039dd6d347327b2d68d0313f3368eee9387c507a812ec99d1bd231644527"
    sha256 cellar: :any, sonoma:        "00df1b94bad75914d80c82460a9d473528b2e4636eb09d141d707fae02f64cc9"
    sha256 cellar: :any, arm64_linux:   "eefabd0078e2de5db7053401427a5d55622c7a058e89e8385bc8489388075fc5"
    sha256 cellar: :any, x86_64_linux:  "eb41cfe4b034b32e52ef0e4fc214140c4c8fb9b3d5ed3a1027a943cf993dd00c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  uses_from_macos "llvm" => :build

  def unwanted_bin_link?(cmd)
    %w[
      testing-commandline
    ].include? cmd
  end

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      next if unwanted_bin_link? cmd

      bin.install_symlink libexec/"uubin"/cmd => "uu-#{cmd}"

      # Create a temporary compatibility executable for previous 'u' prefix.
      # All users should get the warning in 0.9.0. Similar to brew's odeprecate
      # timeframe, the removal can be done after 2 minor releases, i.e. 0.11.0.
      odie "Remove compatibility exec scripts!" if build.stable? && version >= "0.11.0"
      (bin/"u#{cmd}").write <<~SHELL
        #!/bin/bash
        echo "WARNING: u#{cmd} has been renamed to uu-#{cmd} and will be removed in 0.11.0" >&2
        exec "#{bin}/uu-#{cmd}" "$@"
      SHELL
    end
  end

  def caveats
    <<~EOS
      Commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    require "utils/linkage"

    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/ufind .") # TODO: remove in 0.11.0
    assert_match "HOMEBREW", shell_output("#{bin}/uu-find .")
    assert_match "HOMEBREW", shell_output("#{opt_libexec}/uubin/find .")

    expected_linkage = {
      libexec/"uubin/find" => [
        Formula["oniguruma"].opt_lib/shared_library("libonig"),
      ],
    }
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if Utils.binary_linked_to_library?(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end