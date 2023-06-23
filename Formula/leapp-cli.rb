require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.38.tgz"
  sha256 "ceef138fdb5e845443f5902dd2b169b6d721c230e34cc2b5a3ae93e0cc5239ad"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "0ffca5dda74e7cccaad466a65032abd9ef75f4a993c3b3cd87abd5554cadbde3"
    sha256                               arm64_monterey: "fdbf92c1af7329523a2cdef5a68840026c6798ed388914f43fadfe4efec73358"
    sha256                               arm64_big_sur:  "06a2a2b444e18f072028b4cbcea261bb025415183180047c13598a9924003900"
    sha256                               ventura:        "3e3e3570a681b898700ad834d6b18ee20638f92f78352ae84b4b0d41b2db710a"
    sha256                               monterey:       "c129e34f1596ef706481bed174b41bbcb3728c9b5f7bbcbebda853292868cd43"
    sha256                               big_sur:        "842206df3120c4a910ad575104834427d1d59be61e6a0488b81c84281008010e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d8402b435635eeb9e206620f8b0c2a416f59efdf5c8edf599f897dee37ca33"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "node"

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end