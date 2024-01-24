require "languagenode"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-9.11.2.tgz"
  sha256 "2f03abbb84e34a5d8a7ea0c47eb97708600b44dd5d1928a198393d73f82ea079"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24116d0bbc98d2ec15b9d4827d66248b030fe59b2808e2f52153da5abe2473e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66d34932c7b515927ea099e81de438ebcf6b03e966bc1f61df1216dd9729cf30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa83544781142053e46681f6d6c94d8828bca4e1191be239797618df73cfadf"
    sha256 cellar: :any_skip_relocation, sonoma:         "36ffe394be07902b49e637b44c67c1f6ddd432313871aedf0d5ca68ffaefb243"
    sha256 cellar: :any_skip_relocation, ventura:        "fd001813d15d8c063d70486271aa1f57b05e8d63377b613b7cd8e337444c8900"
    sha256 cellar: :any_skip_relocation, monterey:       "94438c69559d83ffd8588e6e7cf096295d64560e08a93c3055cb9a8652af4ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168d1c9f5edc4ab6faeb3f6816b13137e1ed24516e7bbd43bc1be35eceb917e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modules@cyclonedxcdxgennode_modules"
    cdxgen_plugins = node_modules"@cyclonedxcdxgen-plugins-binplugins"
    cdxgen_plugins.glob("**").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end
  end

  test do
    (testpath"Gemfile.lock").write <<~EOS
      GEM
        remote: https:rubygems.org
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}cdxgen --version")
  end
end