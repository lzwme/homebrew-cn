require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.37.tgz"
  sha256 "2a5ec83eac5538ee05abd78a18a77d940e96d51cffc842c164ab5f7b97ab6a20"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "16b6efc01b7345f8484ec01968c2fec77d0e73967954412a503f9589b82a1f4e"
    sha256                               arm64_monterey: "735b34edd9130de5a76a74320a8c70f3397a3f335be0ae0eed4f5f376404a713"
    sha256                               arm64_big_sur:  "930ed1ab2bbcfd6eef938a54bafc41a30a80879bcf3633bf197d3c4fb6e3463b"
    sha256                               ventura:        "bc64f3f751a73c4a8ed38607d89ed4a5e6e3f3166afa2099fdb503deb6ba0a41"
    sha256                               monterey:       "b6e91ef382ac40a09581098208c740a32381d05921eab25fa9139db0bd7442f9"
    sha256                               big_sur:        "777adc712352e58e34eb741a1b941f2c483c8089a2433d160e0f84f6442dfa60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafc02d4eb3561451c6fc39b67779de44f2f5ed389373419eaef7e6458922e90"
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