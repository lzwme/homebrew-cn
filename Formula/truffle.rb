require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.8.tgz"
  sha256 "b640567687cd46902c9d3e47bf67d85303cf4f4bcb89003ba04b7e5580269da2"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "28cc534c6362355221ad5f324583aade6e2a316b3a1fec8e83d08079aec7140f"
    sha256                               arm64_monterey: "bddd2da54cd7a86af2f1814d13fec96e389467307b9699a85b30a5b9f06ee1cc"
    sha256                               arm64_big_sur:  "90cf302ca9b230737370d7656b15c061c6a67e81d739ee3324e92a151945c0e6"
    sha256                               ventura:        "af56cc3bea6eccb6792d22498a914463ccf6db3ef8bebd3f6f0eb016de5cdfaf"
    sha256                               monterey:       "4e13dc8db5b6e57f2b40945408e87bae4d1471b6ff925bf7dee058d62e86702a"
    sha256                               big_sur:        "f21bc623ac3a6ec59e820a15c95c19b325e7f20d901814ad1f08ff0c2b6267f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38fb4a8231b916da92ba8fc0010f0d08c4ccc570eeccec7ee6deb093578bff19"
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
    ].each do |pattern|
      truffle_dir.glob("#{pattern}/prebuilds/*").each do |dir|
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