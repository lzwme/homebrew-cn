require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.4.tgz"
  sha256 "3b01abf16b9e8481524e91b2064a17cabbe68e6614f350001292d4464f569181"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "b271edd62ba7fbcf0cef49133f88df1249c173307686060bd5be1dedf128721f"
    sha256                               arm64_monterey: "909e0551ab265a546c9a9e2a595f2223eeef9302bb37d415378e812b158bad7d"
    sha256                               arm64_big_sur:  "1282245e56c7f058757240b60fc899f743ca27ba42633d413d137dae3ae46769"
    sha256                               ventura:        "cb64167b12cb7602773c02335063d49db65b6e53890e11d1b569a82cddfd8fd0"
    sha256                               monterey:       "11dd0ecc3768bb0a4a1181da70e407a7ecd16b737a47ba600d531d929d2497f3"
    sha256                               big_sur:        "34e7f043c05b3993e5836f6008ee85b99248d86ce5158aac5f1bc4efd4d162e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9bd58d7880c69ffde34b240a7508b11eea6d5dc6ecd8af570c5ca3c7a06a071"
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
    %W[
      #{truffle_dir}/node_modules/fsevents/fsevents.node
      #{truffle_dir}/node_modules/ganache/node_modules/fsevents/fsevents.node
    ].each do |f|
      deuniversalize_machos f
    end

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