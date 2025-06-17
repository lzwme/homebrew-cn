class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.4.0.tgz"
  sha256 "40bbc22c463b885ba884f8ec95f8cadbacf47ebe7a1aa49df68667c301c3115d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b06ddc4473da0d563cc4bf6d9c3adc8c4a4d89bdb0cb577b78ab86542915ab93"
    sha256 cellar: :any,                 arm64_sonoma:  "3d82800f628a248bb5bce2ee74cab716058d4e0fc3fde85bfc8093f02db3ae9a"
    sha256 cellar: :any,                 arm64_ventura: "410476c106a60cdf308db169c661010d3475abd54ab3e1bddacd85c9b25bd2a4"
    sha256 cellar: :any,                 ventura:       "03a356e415932a106c93c6a13ad508f6b3ad82a59fd9ad23aa6a62b8d08f5d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dc5941847a1eaa12ca04b62f1fa02aa641e96c74d4eb1bd4d73d3492c04bb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3020b30bf69bd64f61a76ba42e9a454203095e1b6f97444036c0975c32953eb9"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https:github.comowasp-dep-scandosaiarchiverefstagsv1.0.5.tar.gz"
    sha256 "7fa46508d4ac27203aa4d28da2f24aaca0e1ef7f2ce98a59df8296995c4bd1d7"
  end

  def install
    # https:github.comCycloneDXcdxgenblobmasterlibmanagersbinary.js
    # https:github.comAppThreatatomblobmainwrappernodejsrbastgen.js
    cdxgen_env = {
      RUBY_CMD:         "${RUBY_CMD:-#{Formula["ruby"].opt_bin}ruby}",
      SOURCEKITTEN_CMD: "${SOURCEKITTEN_CMD:-#{Formula["sourcekitten"].opt_bin}sourcekitten}",
      TRIVY_CMD:        "${TRIVY_CMD:-#{Formula["trivy"].opt_bin}trivy}",
    }

    system "npm", "install", "--sqlite=#{Formula["sqlite"].opt_prefix}", *std_npm_args
    bin.install Dir[libexec"bin*"]
    bin.env_script_all_files libexec"bin", cdxgen_env

    # Removereplace pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modules@cyclonedxcdxgennode_modules"
    cdxgen_plugins = node_modules"@cyclonedxcdxgen-plugins-bin-#{os}-#{arch}plugins"
    rm_r(cdxgen_plugins"dosai")
    rm_r(cdxgen_plugins"sourcekitten")
    rm_r(cdxgen_plugins"trivy")
    # Remove pre-built osquery plugins for macOS arm builds
    rm_r(cdxgen_plugins"osquery") if OS.mac? && Hardware::CPU.arm?

    resource("dosai").stage do
      ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
      dosai_cmd = "dosai-#{os}-#{arch}"
      dotnet = Formula["dotnet"]
      args = %W[
        --configuration Release
        --framework net#{dotnet.version.major_minor}
        --no-self-contained
        --output #{cdxgen_plugins}dosai
        --use-current-runtime
        -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(cdxgen_plugins"dosai")}
        -p:AssemblyName=#{dosai_cmd}
        -p:DebugType=None
        -p:PublishSingleFile=true
      ]
      system "dotnet", "publish", "Dosai", *args
    end

    # Reinstall for native dependencies
    cd node_modules"@appthreatatom-parsetoolspluginsrubyastgen" do
      rm_r("bundle")
      system ".setup.sh"
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