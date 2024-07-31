require "languagenode"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https:github.comvercelncc"
  url "https:registry.npmjs.org@vercelncc-ncc-0.38.1.tgz"
  sha256 "0633a7c007ddc69becffd112e5e8a2afa0da0fbf7d6e085122f2ae90e63847e0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "780d77d96277011284e25bf72dae772f0334b4fa205b6fb03d6b240db0450889"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "780d77d96277011284e25bf72dae772f0334b4fa205b6fb03d6b240db0450889"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "780d77d96277011284e25bf72dae772f0334b4fa205b6fb03d6b240db0450889"
    sha256 cellar: :any_skip_relocation, sonoma:         "780d77d96277011284e25bf72dae772f0334b4fa205b6fb03d6b240db0450889"
    sha256 cellar: :any_skip_relocation, ventura:        "780d77d96277011284e25bf72dae772f0334b4fa205b6fb03d6b240db0450889"
    sha256 cellar: :any_skip_relocation, monterey:       "780d77d96277011284e25bf72dae772f0334b4fa205b6fb03d6b240db0450889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d55b94e1f441d7dc759cdec53b73749b4c8a1909857f1e65c3d4869e21e6153"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"input.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin"ncc", "build", "input.js", "-o", "dist"
    assert_match "document.createElement", File.read("distindex.js")
  end
end