class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.8.0.tgz"
  sha256 "a8767d7cdc1dba967da4ecd3d0a75d305d9665d41135d0307f124d72cf064d12"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf6b978341aa7b526e1bd3610849060eef1efcdb7c540470b4293918e1c35b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf6b978341aa7b526e1bd3610849060eef1efcdb7c540470b4293918e1c35b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6b978341aa7b526e1bd3610849060eef1efcdb7c540470b4293918e1c35b6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cca4451c569a62b2ec1e9a26366560810da085ef1eaef1b79bfa90194f447838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85e3a0c22f9aeead21c18d2d823b8a77dad6b8769c321ea38bba72cc672e28c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ba128db8c54eb8c3ac89f2c3167ee4f936d1b82ba94714d316ba0b815391bf9"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end