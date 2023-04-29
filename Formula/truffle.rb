require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.8.4.tgz"
  sha256 "560bd67d6de22677a7f32919f2bda6655782fa818679ed5ebf2cc356dd9ae8f7"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "b0c13021cdb4c761bd54b872289a51de6485b242eb83e772e7ed3a9ecb4aad8f"
    sha256                               arm64_monterey: "4507ab3d1db6df954b7b6ac5557bd7c9097d3717258a89613c429e9773784e45"
    sha256                               arm64_big_sur:  "680fd99fa13f10841c9f9f54757ff43492c73dd0239655e38304e3c5dbba3cb5"
    sha256                               ventura:        "e0c901ff4aca1f6f95666659aecc40513bea0acbb32f7c0da81a83d528842668"
    sha256                               monterey:       "dcf934009231debb88e355fc6cb2f7c55f8e1b765a67352f7ae5f5f8abf82bd3"
    sha256                               big_sur:        "74e32061ca8a0689287610ff1ffc60ebdf1ace951c5438e4e8d8200ca31424da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df9414f1473e48f674ade5336464d7b7d0bf6017ec843c469b6c2decffadaf44"
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