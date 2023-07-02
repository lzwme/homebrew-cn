require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.10.2.tgz"
  sha256 "09250b0a38b1bfad394790b14041d641a791db5e2ac241650bce240a32d4769f"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "d2553b154b9681ae3c2f88f251c2eb997a3a5e0f08d48055b4f84b16a2fd2840"
    sha256                               arm64_monterey: "0e166e7244c6f1c63d14804903c06438274a50823c4b23e4e6f73ca4e50e979a"
    sha256                               arm64_big_sur:  "3f758a3ebb5ef0cbb0b5a5c729989f14632dfd4d9818d07a6b8171999c5d2c3c"
    sha256                               ventura:        "91b70d902dd1c8a7693d440e9d539ea2be194c4818178ef3f4831d66caf23fdc"
    sha256                               monterey:       "9b86342953b621a3bf1094b9e864420f3f8a67a0c77d804dcc12dc976a88a44f"
    sha256                               big_sur:        "5c3d6fd21c5a41530efca2802008870ac5a7b8bbca2b2c6b2ce755c77a0af882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4217f968686277c2a7d3d3d0b22e6b9e579979b0df8636708697b370d18ccc0d"
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