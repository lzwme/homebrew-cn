class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https:code.visualstudio.comapiworking-with-extensionspublishing-extension#vsce"
  url "https:registry.npmjs.org@vscodevsce-vsce-3.5.0.tgz"
  sha256 "fd092586bad4c1684daf9c997fba789eb28a574e55b0646d7df94a258d8e2fae"
  license "MIT"
  head "https:github.commicrosoftvscode-vsce.git", branch: "main"

  livecheck do
    url "https:registry.npmjs.org@vscodevscelatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "79b880f77b49416ff0ba21016dfe1eff4910e4df3fb8a8cd2e1f25eb17ba7045"
    sha256                               arm64_sonoma:  "a82fccb99b1aa0e4b3b330e5013a8d862e47db39b65e2fbf3ff960273139c713"
    sha256                               arm64_ventura: "306f32638193a0cab65039e2caa3c1b7e35d6f20c441ead9d05a1800b6f61457"
    sha256                               sonoma:        "16dfb079980e1d9cd482a8bc7b9c087cf867a500aa9e6453f06512f4f57f96bc"
    sha256                               ventura:       "97445cb532b20d1844e09091550d793365747c26a7f812127f3d99badb638646"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a84098be53b536513b3ea83b6edc146d6d399281c9dc8f448c6d476397c513b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d0e23870896000d924a0665940c67b1e8a63ea31d76d82ed661b4cd9c7ec8e3"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  uses_from_macos "zlib"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec"bin*"]
  end

  test do
    error = shell_output(bin"vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end