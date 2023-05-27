require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.9.2.tgz"
  sha256 "dd636ba5752b00b442e56ce615328227daf9303aed8e2185c7ac5ac9295b571f"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "e18338d7b98219e2ed270efcfa0af89707f7830c56f31487034eccf9b9f0344b"
    sha256                               arm64_monterey: "eaafbff0cf22b580bef2aa2578eb91c8365b121354f74eeb3c6822357f721433"
    sha256                               arm64_big_sur:  "0199b7b8f96b4bc59f89c7fb0682cd02255d4641dd4e7ea21453fe6e7a4b0538"
    sha256                               ventura:        "57aac1457c497c4198b3264ac1666ecdda61bb02293d30a668a41d7c338694c3"
    sha256                               monterey:       "438bca209e75197d77e62bc8b0fb723227eb2f34b28c1c6e595f405ef11f1b13"
    sha256                               big_sur:        "d94e88c813d75190d9aebf56b371e459c0663b91d5c3a71c1d746217608dcdf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aabe73c849a363905ba93ad43ee3896e433a07afadcdcdb062c78a7ba4a9d56b"
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