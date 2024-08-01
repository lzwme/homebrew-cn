require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.5.tgz"
  sha256 "bbc24698fc9964cd80acc8952500f708ef18984096eba9e75f40db3486392347"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "bf976e193aaab626da6ba2c5153e2c73cb8b4cca2085a4eddd0d1af149d35a91"
    sha256                               arm64_ventura:  "e25bde3e668ae14b3548da278b94470c6331c1aab5ad70e12fe84a8a5283054a"
    sha256                               arm64_monterey: "7c9383f39c371ec41e8423c6238fefb205a5a4473b780813343d74393ec220a8"
    sha256                               sonoma:         "4ba206f662ce3535a93392f257a6dd1a53b68c94afb91800bf8194db088bf782"
    sha256                               ventura:        "3d8364ecd6eaef5f0987102fdbd3edfa82553a4c47cadd97619abf548267c64f"
    sha256                               monterey:       "00a57fe89b291ec2b55c81c88e98c72b238690abbff59a5f0f6ef85545b6ad62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8dae03cb8c5330f85e9b7b81937b3ea5100309f64e9990b8def34242ad5bd24"
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
          rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
        end
      end
    end

    # Replace remaining universal binaries with their native slices
    deuniversalize_machos truffle_dir/"node_modules/ganache/node_modules/fsevents/fsevents.node"

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