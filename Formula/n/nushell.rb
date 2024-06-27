class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.95.0.tar.gz"
  sha256 "f41a0f41af3996581f9bd485cfe5d55f26dd486dc3812b386bd43439c72a6d16"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c711bf913853f57ff8e485f1e16ba463665d36994562c8aa610ac85961991ca4"
    sha256 cellar: :any,                 arm64_ventura:  "5d005710c7fe45013f788f544032de55bb8aeaba11797bdfb6636f3fd397c1c1"
    sha256 cellar: :any,                 arm64_monterey: "ccddd2c79c12e44920797267437a6a15716da8d7993bdf626e9960d61f50a3e8"
    sha256 cellar: :any,                 sonoma:         "34c36139c209ae97e25fc9b9e7da35e6c7ce5f055352dea9990abd882d07eb63"
    sha256 cellar: :any,                 ventura:        "d5e075b2739f993981d444904cca866d9599f366a9f516154a20ca69a87ef4b8"
    sha256 cellar: :any,                 monterey:       "af08638eb0dfdf58b629f8db0c07d4b3b420ee6856d5a4295bd07f01be1bcf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9258454636925590dbeab03a9b071429496e0d6e3889d1e99be37b190434715e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
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