require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.54.tgz"
  sha256 "52f5590ff097ea27814c8eac762b5d30e447a560bed68ab75f95635079d7c1c9"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:  "d931a13195b7a2e7153a9bde6f9193d14259356577eaca8b79f14e2514359955"
    sha256                               arm64_ventura: "a57869a8078a5579912401537d3f407ab5ad7487fab0a24414d51aa89fb019a5"
    sha256                               sonoma:        "b140a13f0aed534be9e53fb95a44f3b8ed93435265a15db1f3d4e1ccfc28b0e7"
    sha256                               ventura:       "04aaa49396c6056354ce2a0f938416116c5e8c23ae4e7787f7bd31a369750f9a"
    sha256                               monterey:      "f4d0de542a41bf96c297008ed905b896587a17495381aa508b0f67e7f9233ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bf4f5df2a51d46bc49092b26c27df564f59cea8d6cfc5b8e59947e106a0889f"
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