class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-12.6.0.tgz"
  sha256 "de10d9d2a6a23d5d6cdda8fdd0d9e26eef960a79fdb070e4c6357f5edca20c2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d064170b8a2ac8739b667417cbbd8bdf21567146a91b7b473e8545bc6a8ade9"
    sha256 cellar: :any, arm64_sequoia: "98b712706d0aeb0728bc5458fbdf26cc0c855fce55653e01432bfe641430359d"
    sha256 cellar: :any, arm64_sonoma:  "9df01532b9b987e2e0c31d9891380c78b31d27f13afa739e1ac7c35bee885315"
    sha256 cellar: :any, sonoma:        "f0197f06e44a221faa4da8482d88317457f7f3405b06602aadc614e7fa6a4094"
    sha256 cellar: :any, arm64_linux:   "899574ba7905dbc59c03119a168dc59620d3e60e26ed2eea1719d5365d78b7bb"
    sha256 cellar: :any, x86_64_linux:  "4982e86ccd7d1dfd3e9e156ec06239c5183dc7a8d6de4353c03ee9584737547d"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "trivy"

  resource "dosai" do
    url "https://ghfast.top/https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v3.0.5.tar.gz"
    sha256 "38229e1c3a909e18a76aea6dd126ce7d148c2787da8fdc431857db2af2b83715"
  end

  def install
    # https://github.com/CycloneDX/cdxgen/blob/master/lib/managers/binary.js
    # https://github.com/AppThreat/atom/blob/main/wrapper/nodejs/rbastgen.js
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{formula_opt_bin("ruby")}/ruby}",
      SOURCEKITTEN_CMD: "${SOURCEKITTEN_CMD:-#{formula_opt_bin("sourcekitten")}/sourcekitten}",
      TRIVY_CMD:        "${TRIVY_CMD:-#{formula_opt_bin("trivy")}/trivy}",
    }

    system "npm", "install", *std_npm_args
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", cdxgen_env

    # Remove/replace pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cdxgen/cdxgen-plugins-bin-#{os}-#{arch}/plugins"
    paths_to_remove = %w[dosai sourcekitten trivy].map { |plugin| cdxgen_plugins/plugin }
    # Remove pre-built osquery plugins for macOS arm builds
    paths_to_remove << (cdxgen_plugins/"osquery") if OS.mac? && Hardware::CPU.arm?

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

    rm_r(paths_to_remove)

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