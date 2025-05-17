class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.3.1.tgz"
  sha256 "f01a48c41843b7e6358aaeae3294312ef2f8b59d9635d4aef4671b49ce2c9403"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "57fa4d270319eab154f99190ed853e96ae85afb26aaeb5b9e654c3a1c92484dc"
    sha256 cellar: :any,                 arm64_sonoma:  "4a440203be92739a1a520146bb83fbe01f229bb9378e2d8f418d540b32848b3c"
    sha256 cellar: :any,                 arm64_ventura: "845d121768955fa5ced59234040643dd5f69d655ff5f9977da72d4acc1f9e9e5"
    sha256 cellar: :any,                 ventura:       "eb650fcbba08c1056641c1c947c803c5c5b9cd73ec8c09f18848b49bf90d98fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67d409a7cb5a9f81c98b43433949e797cc2965a7b009950796d417e254ed9a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c25674cd8d5c7c4c6a5148bcc097e94c4931db2a7a06d72d28e0758e2ee86849"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https:github.comowasp-dep-scandosaiarchiverefstagsv1.0.4.tar.gz"
    sha256 "5a944103d0f02fcb2830a16da85d4cef2782ffa94486d913f40722aaf1bb4209"
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