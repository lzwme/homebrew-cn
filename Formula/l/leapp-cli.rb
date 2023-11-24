require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.47.tgz"
  sha256 "ed0dafacdbf47c986dfaefdeea77579104b57960309e9a85935354fc8d4bdd00"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "26efb7062e6426e31e47e6871a9a3783570dec4c42783ee17d1d2e54602a42b8"
    sha256                               arm64_ventura:  "0ad8a0b407a833c39be834661e2a9ad24c0d95c6ed899cdca6850665985d7799"
    sha256                               arm64_monterey: "e7ac3cd5a65a091979af858bd5a974b3548dd77d77d3553d1164f7549e0e9ab6"
    sha256                               sonoma:         "ade397e87b5bf5f74a9b49ab715a19b41341665cd7ead5810a130fdbaa220507"
    sha256                               ventura:        "44aaf6b9609fff9d941b1f45f1827099385c3efeffdebde6ae8a8569c2792851"
    sha256                               monterey:       "9dc39e5ede3b4b5d61848e3f57e006a71e909c552e065c108e05fd1565e55192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc13b2cf4ca093d3d4d6fa23f2bd1809b48dc4cfbe107ea7f60ff2ea46b2e1b6"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

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