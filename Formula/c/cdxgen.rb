class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.6.0.tgz"
  sha256 "40d65d27b3d5ff69669506633f4a5175e2c0e4a5aa1aad1255a02aaa9c904bad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d5a7469d8e7c24a63b8c246988d9d10f681cf3297621bdb6429a98c7f259ee53"
    sha256 cellar: :any,                 arm64_sonoma:  "e48c14944f41366c9058800285d153909be92948e2cc1d6c87d553c89316fd3f"
    sha256 cellar: :any,                 arm64_ventura: "b452014e43100d746bdcbbd789cab7adecfafa8030e59f49f9e57100e4170999"
    sha256 cellar: :any,                 ventura:       "e13b06e166d8f6ec20bb7ced04e9ee0fa76c81c91f303046f56841be567f7c74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e38166934fa8f13b2b3ea1cad8486390ddaaea61f9787802347a36c04c8847ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2a4234b8b50290e55899350f080646c93bd565d17c14d23d6b2958c1abd5ba0"
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