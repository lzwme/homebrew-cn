require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.0.tgz"
  sha256 "459fd14426f35898ae359bdee51459437cd03a790b7694e60e38488da027430b"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "52fe449692051268d97804afea95c55d8cda9f12ea80dd4fd6aa09f3dc3d43c2"
    sha256                               arm64_monterey: "817c75a1672d0c881fc2a1766f1f10a51ae8e6c6580dc3db8a5164246e8aae38"
    sha256                               arm64_big_sur:  "d29b7487118df83326da1631f0fa97b21d0510d92f9f61db014256e1e873a29f"
    sha256                               ventura:        "e8e066b7c67544639a3455733d2c292680ffb656706d3c0a5a1170c1770e728e"
    sha256                               monterey:       "008e94a7c59df76db459921e5a20df09417170d59de3bf0ada244a97cea078bb"
    sha256                               big_sur:        "4ec6e65a5b39243439daa21e226e54c3aa06b0dfea27218908511080cfc964a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acaf2ee5c9f68db4c636cfb775da7fdd29b77e7230978f22723f4e55288c83d6"
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