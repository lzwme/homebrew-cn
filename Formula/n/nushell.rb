class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.88.1.tar.gz"
  sha256 "19f5a46799142117f61989a76f85fdd24361fe9e5068565d7fff36b91a7a7a39"
  license "MIT"
  revision 1
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a468c23570ebb831562c642a7be08638d753f7128ff528ed194f6a540d431c8"
    sha256 cellar: :any,                 arm64_ventura:  "7c464115a94d81340f1f1537a0049536569d44921cbe0a8121ac8d82355e0f7b"
    sha256 cellar: :any,                 arm64_monterey: "dbe40d0ff74a518749038364de4fe46398a437a632248fb1364d6b71af2a514e"
    sha256 cellar: :any,                 sonoma:         "67cc14f11063e02ad3e74b2611533bcc51f402906c893f31109869aaac384611"
    sha256 cellar: :any,                 ventura:        "ee05c23fb557c1244a99223c7749daec5a76a298626210e112a41c089df6ad5e"
    sha256 cellar: :any,                 monterey:       "f3724705506139134f3ad2f12cb641657699b327d93dea1e2cafd40181801d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f182b3ecd013f4b6551e2e01c9efe9d557a00b450a76efde8e39bb8a516d9b4"
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