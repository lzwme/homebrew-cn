class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.2.3.tgz"
  sha256 "78369fccaa389210a37e8e672f0c9d0930611efefb60459be0a56ea54b6bfdd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7534af6f9772e6127e3f463d74b7fb848cce7bbd9eb297d3750740bec55cf59d"
    sha256 cellar: :any,                 arm64_sonoma:  "a33884a4b63d119dc61a72ce8a1c202b080589ef08206ab3bcf7cc1cc0cb045f"
    sha256 cellar: :any,                 arm64_ventura: "7f50733fa47f47835c0dac98794cb6c9756cf1cfbb6e2ebd1bf3863eacd6b940"
    sha256 cellar: :any,                 ventura:       "3243a723b7c052496f54792beaa85c0023d483e42ea0064701b5803015cf46b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4658b6974940f872b8c4d77b148bf7d295deabbfc30df63fdf4fe5162c89b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5595d1b46218a66e555ea9598af4c6628c0dc813e11f61311c57e5b23a3eaed3"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https:github.comowasp-dep-scandosaiarchiverefstagsv1.0.2.tar.gz"
    sha256 "8dee3b328f58c75b62be9acbc26e00d6932599985c47588feb323c900fba6688"
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

    # Ignore specific Ruby patch version and reinstall for native dependencies
    inreplace node_modules"@appthreatatomrbastgen.js", (RUBY_VERSION_NEEDED = ")[\d.]+", "\\1\""
    cd node_modules"@appthreatatompluginsrubyastgen" do
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