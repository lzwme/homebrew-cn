require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.9.1.tgz"
  sha256 "33de8538734cb57e160bbc745a4e89be54988c8a7d1d3038ee88762cadffc96f"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "07df07529a184b7f2ebcbf009bf3b9316369b64751eb0f52fb38d13b5df34c78"
    sha256                               arm64_monterey: "a009524749ed021d7137f3eb8cfcafab021f5f9a54812f47a17ecf5ad67067ee"
    sha256                               arm64_big_sur:  "62f7f60b8fb17e23aef955513595ec3c4b031ccac4c60ecd682ea4273e0e4b39"
    sha256                               ventura:        "2e4c4b3ef692e1cc3f39eefb4be5290c4e6d98ac4b2ac74a6d14d26f59c51caa"
    sha256                               monterey:       "4352290dfc7d64ffb7da153ae8b5a0dec8374593c3c50c85b931ae0e3b85b924"
    sha256                               big_sur:        "8dc70ad6077a187d9c716f25faebba9148a5afa52e4e0fd3c9d37d1747502a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11726ed23bb1f3cece25a618f59e7ac6f44dd972fe6c459706af2f4d5608c28c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    truffle_dir = libexec/"lib/node_modules/truffle"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    %w[
      **/node_modules/*
      node_modules/ganache/node_modules/@trufflesuite/bigint-buffer
      node_modules/ganache/node_modules/@trufflesuite/uws-js-unofficial
    ].each do |pattern|
      truffle_dir.glob("#{pattern}/{prebuilds,binaries}/*").each do |dir|
        if OS.mac? && dir.basename.to_s == "darwin-x64+arm64"
          # Replace universal binaries with their native slices
          deuniversalize_machos dir/"node.napi.node"
        else
          # Remove incompatible pre-built binaries
          dir.glob("*.musl.node").map(&:unlink)
          dir.rmtree if dir.basename.to_s != "#{os}-#{arch}"
        end
      end
    end

    # Replace remaining universal binaries with their native slices
    deuniversalize_machos truffle_dir/"node_modules/fsevents/fsevents.node"

    # Remove incompatible pre-built binaries that have arbitrary names
    truffle_dir.glob("node_modules/ganache/dist/node{/,/F/}*.node").each do |f|
      next unless f.dylib?
      next if f.arch == Hardware::CPU.arch
      next if OS.mac? && f.archs.include?(Hardware::CPU.arch)

      f.unlink
    end
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end