require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.10.0.tgz"
  sha256 "314aca7e0f7a35b7beedba6afa1da18cf388372e26b9ebb39e0ca98819d008da"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "f8be2d1e7100584d8ea9e3e503052970059204aa647a829b90656d9b3d6271ab"
    sha256                               arm64_monterey: "222297a368605f154878eb18c0e7f5048ec434a4872a8c2bc6a08a7d9e5d9337"
    sha256                               arm64_big_sur:  "71e5aa02eaca084f6a999f65ee680cdd1ccc16caa2048a55fa6587cd277345cd"
    sha256                               ventura:        "7f2be7f0ccfebba0b5ea62d21dceec907a3fc296c6bb374e7f6bb744e360f9ef"
    sha256                               monterey:       "292433f94e3c4a342e14558deb3a259bf9f518e5bbe82603ff8e37a6eb8e5db5"
    sha256                               big_sur:        "59f49953fb4b6d59c2add0b2680663306d89327a8a5f315c3883cdb2ea593068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d673f352b0bbc690b91920c3a0bdf5a772643aec89273eacb4034c7a02ae69"
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