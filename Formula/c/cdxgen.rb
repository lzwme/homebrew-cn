class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.5.0.tgz"
  sha256 "b2d2b03b6c3ddc8a55575d3b2f2c90f94af0029f97ddbf2ea262b43c2f2c6cb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c64566cd327d6563c60b0a2dadae333d7da86abedda5fba52edaa7711a38b3ac"
    sha256 cellar: :any,                 arm64_sonoma:  "744cae00295380042482d8e39fd52df846f357462660d898116fb70f4514e6aa"
    sha256 cellar: :any,                 arm64_ventura: "9f48dc8de2ee899bbe20d218db06ec4fc089ada3d8a4fade0b5b1e6f2b2cf158"
    sha256 cellar: :any,                 ventura:       "6381e8c57b97836826b5df31ce4df8b704ca0c67cdff8d6d7716385a529904ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5df861fd474291b10db006164a610c75fbaabdc84a837fce5b09cb560ec729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e867d2b2da549272d01aeb8d6adcdcc637078fee31ca9905c5dd7c102fbc2b19"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https://ghfast.top/https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v1.0.5.tar.gz"
    sha256 "7fa46508d4ac27203aa4d28da2f24aaca0e1ef7f2ce98a59df8296995c4bd1d7"
  end

  def install
    # https://github.com/CycloneDX/cdxgen/blob/master/lib/managers/binary.js
    # https://github.com/AppThreat/atom/blob/main/wrapper/nodejs/rbastgen.js
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{Formula["ruby"].opt_bin}/ruby}",
      SOURCEKITTEN_CMD: "${SOURCEKITTEN_CMD:-#{Formula["sourcekitten"].opt_bin}/sourcekitten}",
      TRIVY_CMD:        "${TRIVY_CMD:-#{Formula["trivy"].opt_bin}/trivy}",
    }

    system "npm", "install", "--sqlite=#{Formula["sqlite"].opt_prefix}", *std_npm_args
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", cdxgen_env

    # Remove/replace pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin-#{os}-#{arch}/plugins"
    rm_r(cdxgen_plugins/"dosai")
    rm_r(cdxgen_plugins/"sourcekitten")
    rm_r(cdxgen_plugins/"trivy")
    # Remove pre-built osquery plugins for macOS arm builds
    rm_r(cdxgen_plugins/"osquery") if OS.mac? && Hardware::CPU.arm?

    resource("dosai").stage do
      ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
      dosai_cmd = "dosai-#{os}-#{arch}"
      dotnet = Formula["dotnet"]
      args = %W[
        --configuration Release
        --framework net#{dotnet.version.major_minor}
        --no-self-contained
        --output #{cdxgen_plugins}/dosai
        --use-current-runtime
        -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(cdxgen_plugins/"dosai")}
        -p:AssemblyName=#{dosai_cmd}
        -p:DebugType=None
        -p:PublishSingleFile=true
      ]
      system "dotnet", "publish", "Dosai", *args
    end

    # Reinstall for native dependencies
    cd node_modules/"@appthreat/atom-parsetools/plugins/rubyastgen" do
      rm_r("bundle")
      system "./setup.sh"
    end
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end