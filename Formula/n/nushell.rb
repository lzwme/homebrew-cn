class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.105.0.tar.gz"
  sha256 "2c2f4062820602a773682c5b9189d52ddc03793bc2a5d367d88f73c604f290d3"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7248e8f08c9f7893bfde041e0a6aff3d000afe649c903acf67b6d368725bc695"
    sha256 cellar: :any,                 arm64_sonoma:  "fa922ada8e5e18b93784b02d53db3960446c562f51de4419fceddd5369460e9f"
    sha256 cellar: :any,                 arm64_ventura: "107fa1d7a24fc4596ca4c82722f7eb31af98ee98946b9c4f310fd12e7a05ea9f"
    sha256 cellar: :any,                 sonoma:        "2f05fc73175e605b612b525c91488f380f46d9f14099678b012275a147514106"
    sha256 cellar: :any,                 ventura:       "fc5a0f8e837c0ebc12b9ac213eaafec710b75988eb15d040f8ba729c2950eb90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "810f62e020da0a7965a4930a965dcbbba981269fbb3d21ae9c47a97f9af80cd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5a80bf0ffd65be22913d0a95ea78e169bf871387eee0dfbb45f7343b7c7caf4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
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