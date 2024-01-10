class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.89.0.tar.gz"
  sha256 "1d7a7cc960bb8265214a7345ea3787a5bc22dcb7099d5c5056163df025c5527d"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ac3a89c4acdf8ba41c231871f6bd1b810ed15f865248be2f398741cd79e1089"
    sha256 cellar: :any,                 arm64_ventura:  "b26942be02ed32e67d10a76414876e374d138401c3075296aab4477db1d5be06"
    sha256 cellar: :any,                 arm64_monterey: "2aa64be6ab940e6389fd79aeb60a908bc24903f80b95fe87d855283064369c7b"
    sha256 cellar: :any,                 sonoma:         "d70dd09b1f0f4c3596a60c3a69fe7313350488a1e38ebd2adf20b714800fde8e"
    sha256 cellar: :any,                 ventura:        "16961541643bd3e4b3c94bd45ae51e0816d0c4c6f2a5a145a94759bf49511f8a"
    sha256 cellar: :any,                 monterey:       "099008d6e47aabb9be22e2df0917778303b666b738e9d4e724fc7f4f1242376e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eef8e2e992c43ca682ad29320728bdbdf751407e42820060f9ad6f7efc598f4"
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
    system "cargo", "install", "--features", "dataframe,extra", *std_cargo_args

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