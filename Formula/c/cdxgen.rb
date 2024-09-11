class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-10.9.10.tgz"
  sha256 "552063ce6f419bdea4025156cfddb6af5d3d693ac27cf19d20bc885c25506704"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e90960b1468ae90916be724df2a4e46601971c451ca11249aa225e57db0f62d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "344da6e2919371a1a6a26fede38587fb74c0de75a7c570ca4bad7be3335eed1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a009f555b023bba7663b3683828a1078e4e189df0320e6ca4505d6fa1588530f"
    sha256 cellar: :any_skip_relocation, sonoma:         "361151cf2f9617cf0c3132b3d1d6c8f99cfaeb80fe651b3f617668df555cbcdf"
    sha256 cellar: :any_skip_relocation, ventura:        "f9f358309a3501eb2563eab14e3e211818a372eca123a4281aa2f4b3a7207f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "9559a2f3ce791748bdbdb2c1bb10ca1b6466c39f652c288f41421473386111a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbcf6fe943f58ee36f1b965d01852b87b3b1b9d04b749a0347af46602b098f81"
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