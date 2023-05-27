require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.42.0.tgz"
  sha256 "532d4a9774f150c2fd83dd7cbe91ad25f1d082880cfe9f8fc7dfbd8fcfa6ce9b"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "8de54a2fcd5f1538541fc89b0a0f753c9f6a38477c261ee59e3b053833a8eeb8"
    sha256                               arm64_monterey: "8509789b668dc17a5c44dfa17af598fb6d5ff2ff2f8c9bd737090906eec79f91"
    sha256                               arm64_big_sur:  "c915cc84ca1ab21038d775218d29d9791502a5011846e8c0db62c0c697bfbc9a"
    sha256                               ventura:        "cf0704135ad90f7022940cab60cb0201955c946002a2845feceb8e61da89f3f7"
    sha256                               monterey:       "fc06fa78647eb9454a5edc6a1dd6e0a421905965ea0231ff5c6a04d4218877de"
    sha256                               big_sur:        "a773048acd3d1192f02dd9301b24511fa2ed320e5c9fe2e7ce16f905a9828dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "341817409b30e2fdc1ab7dabd21eaf117cc94b83e3b123f751109a63c40343da"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end