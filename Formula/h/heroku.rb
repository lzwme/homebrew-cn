class Heroku < Formula
  desc "CLI for Heroku"
  homepage "https://www.npmjs.com/package/heroku/"
  url "https://registry.npmjs.org/heroku/-/heroku-11.10.1.tgz"
  sha256 "40d1684b16bb7f4001b781e8f5503cb697151238eb2fa4bb856001cf3bc1a290"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d5238103e046765f862acfd31d57bd71b4e6edf44c5254f65e8d484e0e66b51a"
    sha256 cellar: :any, arm64_tahoe:       "d5238103e046765f862acfd31d57bd71b4e6edf44c5254f65e8d484e0e66b51a"
    sha256 cellar: :any, arm64_sequoia:     "d5238103e046765f862acfd31d57bd71b4e6edf44c5254f65e8d484e0e66b51a"
    sha256 cellar: :any, arm64_linux:       "ec87da0afd8b3ffe843eae138b80ba0a10ab6ce8b0ce44aa2e9df768cb799d09"
    sha256 cellar: :any, x86_64_linux:      "4a08a498619a0da22fbbbdcfd97f0335a9a15e92d910a83d0120f80ef3920f57"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/heroku/node_modules"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Error: not logged in", shell_output("#{bin}/heroku auth:whoami 2>&1", 100)
  end
end