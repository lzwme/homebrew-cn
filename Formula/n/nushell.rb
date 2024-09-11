class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.97.1.tar.gz"
  sha256 "e605d5a7f104b7f2bf99197ca2f34a4a68f68cc12ecab41f606113e6a65b67b1"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f5432a6b21c859c05540069cb77c01fb5a33067707638ef04584ae745e56adbf"
    sha256 cellar: :any,                 arm64_sonoma:   "3fc605f1c03b02fdfe2b919c37e58e27e6ba8be3a0ee5888e91acb9822db3673"
    sha256 cellar: :any,                 arm64_ventura:  "85ff5bcaded3f91f261d8195d9e5e67151bfd4e025982a140c69f8a5bf73bb93"
    sha256 cellar: :any,                 arm64_monterey: "912bf69facc8a0c108674d27a1e5f25ec7b05dcb76415528f4d3f6912c1b9bcc"
    sha256 cellar: :any,                 sonoma:         "e6f1ab643d136ff3a2a7b523ca379f3db88a47d3a9d6f4084c0400c5b8e4efd1"
    sha256 cellar: :any,                 ventura:        "557044b4a783e955f4507b69dee22ed533f1e2eb4a2d8fe5c0130d6bf1112689"
    sha256 cellar: :any,                 monterey:       "2038ad3f2a6221ef69f19d910ba00ce15829ffe7278c08dbd78f4ba541cceabb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370cf7a4ac285a1ded125e2d7d24711648633abb7ce3eeda5ad7469f77c8b8fb"
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