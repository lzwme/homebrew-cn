class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.5.tgz"
  sha256 "f75b11255d654f0edbc976bfd3078920191a65c70bb04a1c5b6da084ab0f3ee7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a5af683d55cd7a35330e779764eb7fc6b8a2a3e5e744b051818156473fd555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a5af683d55cd7a35330e779764eb7fc6b8a2a3e5e744b051818156473fd555"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0a5af683d55cd7a35330e779764eb7fc6b8a2a3e5e744b051818156473fd555"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b55f9edc230501fb9be72d6e8bb99487c08ef3add373497cb6d3b6df767d6a"
    sha256 cellar: :any_skip_relocation, ventura:       "43b55f9edc230501fb9be72d6e8bb99487c08ef3add373497cb6d3b6df767d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3df543cde58366aae6c70316e07afe5ecb76ffae37376e6bc5eaaa851a620f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e74d8dd3db91ac22e88eeaa379385cc50999a22b17506bed26fadb5fe1e4dbc"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end