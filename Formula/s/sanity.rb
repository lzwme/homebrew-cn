class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/sanity/-/sanity-5.27.0.tgz"
  sha256 "723b1da05828c9ed2e49bbfef14659ea31676a67ce747f9189ee61eec4ccd18e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73aee46847c64e39567905bb9cf97bb7c9eac9da3ef8cdaa4b17c82b8345e8bb"
    sha256 cellar: :any,                 arm64_sequoia: "4f76e67085d48ab11bdcfc5e54f2177401f928240eb549a0d4c2aa74af3a3a92"
    sha256 cellar: :any,                 arm64_sonoma:  "4f76e67085d48ab11bdcfc5e54f2177401f928240eb549a0d4c2aa74af3a3a92"
    sha256 cellar: :any,                 sonoma:        "128a115b00e2d40b8e8ba42be0648ee5268c6969eead5bb73ba9f00b2b3b5ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85783a2314d4fca6f9e82613b1730e9bd559ee0118e761674bebbe3e0e7a3de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d0b66b58c09fc054bacb20cc83abb238e4f384b433afd109350697f49ce576"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/sanity/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end