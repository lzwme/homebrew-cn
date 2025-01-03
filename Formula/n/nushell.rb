class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.101.0.tar.gz"
  sha256 "43e4a123e86f0fb4754e40d0e2962b69a04f8c2d58470f47cb9be81daabab347"
  license "MIT"
  revision 1
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62e10339cf5c4ff5c7843d847e4273196db19ae731acdf13dc69e812ea5720d0"
    sha256 cellar: :any,                 arm64_sonoma:  "0ddf79eae5d8ebd70131436862ea88fd0f8edb1882057061bf9bb82636b78818"
    sha256 cellar: :any,                 arm64_ventura: "ca2991396f58784cf3cb26924b8d940610f787f195d64c32514b167c34342a16"
    sha256 cellar: :any,                 sonoma:        "6fb7e6320828abfaca040d0afc32da95df84fef057220df6c78881bca559a83d"
    sha256 cellar: :any,                 ventura:       "d892426eb6a147c2abf2b94808caabe64ffd4f25a56b60eceb510dccb78bba4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77c7dd2a77f4cbfce2deb012c6481a8c7898615216f320e8f887dc688f693be"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libgit2@1.8" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

    buildpath.glob("cratesnu_plugin_*").each do |plugindir|
      next unless (plugindir"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end