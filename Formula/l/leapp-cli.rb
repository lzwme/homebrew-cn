require "languagenode"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https:github.comnoovolarileapp"
  url "https:registry.npmjs.org@noovolarileapp-cli-leapp-cli-0.1.57.tgz"
  sha256 "e8b840fa77dbc2c97cc2821c4be307569cea0b1e04506d7f5db366f9841f5869"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "44da2f9e18bb99ad5cf00820339bd088a162cb8e8788d7e94626ad5387695df6"
    sha256                               arm64_ventura:  "715bcf24d279d0f0cb4b54f8792ecbf85c760acf031c959766fa4ae4a10c5613"
    sha256                               arm64_monterey: "59b1738bb4471dc4e076fba1f107645cbdca72f1bf919a3859dd5fdfcf869f70"
    sha256                               sonoma:         "f33137e87bf1b5e9dfe01cf010f7c609449026026dcaaed916b46beb1a60724c"
    sha256                               ventura:        "cec41e8f082374288f5e39358486df842113aa515e63cd6f91b5e613fc7e1717"
    sha256                               monterey:       "30117373cde91b9a72e09f82c105ecab632135c27a53d895fba023d053d0010e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a07fa5ca304c01dbd7a10d295f59361a67f56c5670fd7acd8237e93a5fa89ff3"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
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