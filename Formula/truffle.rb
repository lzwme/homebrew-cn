require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.9.0.tgz"
  sha256 "581cf5686d68fa322ca9cb09e86f77d7d8aa7c8749e4f609adc57490c86c3278"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "4fa853ce2a5ec1c1887b5d4e4cac411188fa8804c0ca0e60fed10c6d3f0784bc"
    sha256                               arm64_monterey: "afa0a47bb4ac081ff89cbc1a5ebcc96c92079bf02828a88f23676a7e59ca993f"
    sha256                               arm64_big_sur:  "733fa2aaec7a154179d2419b26105c6c58261802397caf267e6996cc641e0659"
    sha256                               ventura:        "6848f7937a8fff0c62381de51de59b51fdc8c87b08e3b6cc06a510138ff383e7"
    sha256                               monterey:       "73ed3caf4b95c5df8fb9e7481b9898bf34b164e1dc478bc19aa1ef68a41e0677"
    sha256                               big_sur:        "fa371df40fdeecca114ccd5ce1ef248bc252416c5c2fd00595b2a625538d3f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a4e3bbf5ffbc70ec0114814545f53f640df13445caf0072cd72a811b104dd8"
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