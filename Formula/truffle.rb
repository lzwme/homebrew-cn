require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.9.3.tgz"
  sha256 "aed712bc7b220cc96ff1ae4b7eff8ea7bd0bf1d7ca7be6cfd42e5cd7b71a194f"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "2bd72dfa942dcd964baae79ddebf15689ac581b540c57137a86a27d888ae3dd2"
    sha256                               arm64_monterey: "6b0a9c3019c2191623c9928f9de4347bf102f9608f09e6a7d6105bae3642be85"
    sha256                               arm64_big_sur:  "8c2fc86525a45f74cb981de2c3296e3a512ca9c4d47353ae0fe7ee598e3f92eb"
    sha256                               ventura:        "d5c2e69d5d103ba09eef529c880a3a9c3369872ada2ed748423e968c417dd316"
    sha256                               monterey:       "d44d98611be727438e8284ceed491426593abdcc3c45d5818207134f9fa9c688"
    sha256                               big_sur:        "fa3416f644bb9e93557a4ce87f6362ea6e4b679d3ab33c5c0b85b8c47555b86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92033bb1b80f7d16d5ab498fd0b837befb82b6a71375c5d700dd11c37a705e6c"
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