require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.4.0.tgz"
  sha256 "99c14357bb9ee6a9a41743a28480f7216667ac8d86eadab84d3e13e0553311a7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "090a265c814391e205718e080e15d5cf7d9cdb8f59ddd9b094112c30e329e290"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f1d84cfd209a8943dfaccbe9476db6edf4f1d331ea8c571935b85ba135bec80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae99f28ff5e88525df8c1e2e3261be2e3ed7fe3854ce2d3be011563359b34baa"
    sha256 cellar: :any_skip_relocation, ventura:        "b63d287ee628268b9b1fb42b162347beb92e194fd6482f9dd54287cb7ba0a460"
    sha256 cellar: :any_skip_relocation, monterey:       "ae1eb0acd1ffdc81c17c8e2082fb07424854b85909602b5a951688126049eaca"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ae618c680db10f1d08de7a7eac53cf00ebdf84db746b2496b3b738ed35500fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1639cd87ad4b864237b1aba76109282c8288fc5b2788e62643de1d8185c0adff"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"bw", "completion", shell_parameter_format: :arg, shells: [:zsh])
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end