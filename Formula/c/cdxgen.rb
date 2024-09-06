class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.8.tgz"
  sha256 "51784e7fc776433625e3c682655e4067a13f8ac9b9c6a2a7ea027846f3cef4ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70185071d20d3aba2af6f1d9bfced661a71c078677570ec9483f7da3aba1849c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18b7557a1e55c859a6ae3574825bc4e6f4b669877ec3c5c49ecfa42a54756f86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0924192fdda9e39c4807b31a5b2ec015ba168994a4b61a781b62661a29004ddc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c5ee6725f03a9e2f6aebf20755cced5f42da0a5b7703cd7b7df83356b0f5aff"
    sha256 cellar: :any_skip_relocation, ventura:        "63c51d3478338f695ac87bc3e911c65749343c99e3a25296eb515d96433e12a3"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e31db01e3ab50f5515377d6f90c9cf8ba5246577d7cfa8161e04085dfe147c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de9134ebb31926a44bf84d48f2c3788bfc16e2b11d46e12523e80ce0d666b7da"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}cdxgen --version")
  end
end