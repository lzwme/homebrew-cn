class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.1.6.tgz"
  sha256 "bda1717176eba0ae9484c5d1687294d465885b7cdf9f5a26fd166e2bacf7d048"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3aaae07b8ef0dd1a7f4bdbdbac1c28cdf70faaab00e5335999cdc0e7b9d10110"
    sha256 cellar: :any,                 arm64_sequoia: "ebbabe4dc088a727029cc5cbb8e2871a1aec3bbe5f0c3a8e0a6ea5ec45fd0e14"
    sha256 cellar: :any,                 arm64_sonoma:  "ebbabe4dc088a727029cc5cbb8e2871a1aec3bbe5f0c3a8e0a6ea5ec45fd0e14"
    sha256 cellar: :any,                 sonoma:        "efe04785ae23f01bf12c6d54de5065eb2a3eb42c552dd5b4f58162f669a0870a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1d35ffd213ad8972dbe3649b55fa5d402637ed8687ac6507567cb226db5ec07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a207d07043f8388fb75e1cedf85672362d358e3692cf63708db795226782da"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Rebuild rolldown bindings from source so the Mach-O header has enough
    # padding for install_name rewrites performed during relocation (macOS only).
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.mac?
      cervel = libexec/"lib/node_modules/vercel/node_modules/@vercel/cervel"
      rm cervel/"node_modules/@rolldown/binding-#{os}-#{arch}/rolldown-binding.#{os}-#{arch}.node"
      cd cervel do
        system "npm", "rebuild", "@rolldown/binding-#{os}-#{arch}", "--build-from-source"
        system "npm", "rebuild", "@rolldown/rolldown", "--build-from-source"
      end
    end

    # Remove incompatible deasync modules
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end