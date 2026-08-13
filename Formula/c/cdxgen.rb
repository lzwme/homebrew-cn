class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-12.8.3.tgz"
  sha256 "7c556687515f2553982716143e0b9515474c77610c2f978aa06ffecc14cf8536"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c0872203842b0cfb74e155cb452b42a11502d7bfd9ee476e65a3074dd34c701f"
    sha256 cellar: :any, arm64_sequoia: "8dd5bc1d013e0c6cb9e456a50da15e82a2dfbb60608e8ff00a85ab36a4cb383c"
    sha256 cellar: :any, arm64_sonoma:  "5151ceadae914db5bdef87b21a5707fff5a0bfd0f7d255eac1d08c905483e5d2"
    sha256 cellar: :any, sonoma:        "8081f2f039e36498f4c6b8d21b2d56a9b16a8b7ef9bbabf539fa774dfb4d98b9"
    sha256 cellar: :any, arm64_linux:   "3ebe7ecde8c8a65bc9f8e0d10cbe7a8e20efbcd1d3720b486810718a96df7563"
    sha256 cellar: :any, x86_64_linux:  "9f4157484e02e78c566a08da5f3415c455b9d79fd5cdb1ab3ba06a1fcb019ba2"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "trivy"

  resource "dosai" do
    url "https://ghfast.top/https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v3.0.6.tar.gz"
    sha256 "ab7a4338e2f14f8f357bca95497d086939a396012a3c3a0cbf39266c43668240"
  end

  def install
    # https://github.com/cdxgen/cdxgen/blob/master/lib/managers/binary.js
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

    generate_completions_from_executable(bin/"cdxgen", "completion", shell_parameter_format: :none,
                                                                     shells:                 [:bash, :zsh])
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