class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.99.0.tar.gz"
  sha256 "db9799a164e21798d7c7da800623069c056f30e6b35d7cb03bdea796f3a4aae8"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c86aa175ca075607e55a4782d17b3d3a8e3d37cd54c504dcf8044824d0a03519"
    sha256 cellar: :any,                 arm64_sonoma:  "116ecae034bfb81b9a4f43bfa5476b90ce0fe8c094b61b33dcc8ed04f70467b2"
    sha256 cellar: :any,                 arm64_ventura: "5e8913acfb1ea94022f486f1cd06e99690068549dbcb91c73f49e810635e74f5"
    sha256 cellar: :any,                 sonoma:        "6725e25f7aa3b23abdd33a7155ec60b81183fbeff757b962e82ba60759ef2f66"
    sha256 cellar: :any,                 ventura:       "5bd6e172c7027f08ccdbd9f838c481154c0d386c4b678b509569f3ce9047a81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "178424bdc6edeb9abda6f1ba8c65cc9297708a17066bd14bd88ba82af976fe1d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
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