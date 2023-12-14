require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.51.tgz"
  sha256 "e2fc3d74727408df95c0b5bbe34937c03dd9d6453bfb72c0cedfb093a71f2f8f"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "2d250d0abb6bd50d3400b34b4c45d9d83d4cae5a321ff5f666bd4f4c3b224973"
    sha256                               arm64_ventura:  "30f7055616394de28c3ac2ea0efe978bf2a3f254076d9384c34833b885b3366a"
    sha256                               arm64_monterey: "9d22351d59ba203e448b4ea43718297448bb6a7b281f6bc5d306b9e51ec569d6"
    sha256                               sonoma:         "e0478a6f5cd272a1fd89976ff0a2e87e42b1d628dba03a568091d055080a6d6e"
    sha256                               ventura:        "ee1fbc92952803cbc35dd501ce98040f6f867653df6a59fb69c0aed98ca92c48"
    sha256                               monterey:       "191afb3b2b101f2f3ec40442ff130983c97958b4b5fd303ca3224798e0ee61f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c043494c0862246a76107bcca84cb3da0faa5b7721a6f2d2a11336d21ba5154"
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