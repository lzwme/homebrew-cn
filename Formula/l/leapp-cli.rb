require "languagenode"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https:github.comnoovolarileapp"
  url "https:registry.npmjs.org@noovolarileapp-cli-leapp-cli-0.1.62.tgz"
  sha256 "2d0282269cda0f6d9b2ad7c149063a4b92c334275b179e8874440200ef8cc773"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "deffa9adf0d47396301b9ad4bb30d109785916439f1ee4a79c7d4557098b0c60"
    sha256                               arm64_ventura:  "8d285cc6727a5f07bdfad177dd08e7790c18aa4b291b755c481c9c78557bb924"
    sha256                               arm64_monterey: "76600d7e5e37cd72d2b9b7ca743499abdecfbefaf9d5b95963f41dcf91ae70fc"
    sha256                               sonoma:         "16d6befb120ffe1c2352052381acc6317daa1d00e0c6b35914be81e437a64ab4"
    sha256                               ventura:        "d72e62db93d5eb39d0594c0b0e38944b914d98a2c2d16bbdae2fb5754b68768b"
    sha256                               monterey:       "6cf9671f51297254cb7f829fc5e28e7c4d5971ffb0855f3f7862fb7792436bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f21031d62da1ca0659d724ff4e59a06ce3f702373d5bb845829e51050996d99"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "python-setuptools" => :build
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
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
      shell_output("#{bin}leapp idp-url create --idpUrl https:example.com 2>&1", 2).strip
  end
end