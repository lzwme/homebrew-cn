class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-12.1.3.tgz"
  sha256 "a8688979d6a0b5fdc2cc526d198a9df91c7804b12715452c12344c31229193c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec914c4bc9ae75a1c0e119dd5b31019f7852319a9bef2125033b8a0615e88543"
    sha256 cellar: :any,                 arm64_sequoia: "ee82130ae749206eda316ae18ea5e4b14dc6aebc93bdd6223ab046da74e1ee97"
    sha256 cellar: :any,                 arm64_sonoma:  "21d270f2ba4c1718b284cb3d278464ce05a34c00a3ae94ffd85788c147cafd61"
    sha256 cellar: :any,                 sonoma:        "a8c10a5416f9938cac7af72deb96a80b55a24cd426f3aa5f873ea33f92fcf4d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68bef0fb284c8160e8c5ad18d423b7dde611f76012e47e6e3a62f5c9fa7b822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c8e3ac1e6f91328b1488f11122770c2e713d92a9a71720e6dd2243d44e117c9"
  end

  depends_on "dotnet" # for dosai
  depends_on "node"
  depends_on "ruby"
  depends_on "sourcekitten"
  depends_on "sqlite" # needs sqlite3_enable_load_extension
  depends_on "trivy"

  resource "dosai" do
    url "https://ghfast.top/https://github.com/owasp-dep-scan/dosai/archive/refs/tags/v2.1.1.tar.gz"
    sha256 "b17b6abdf651e50aea6de4b7652ac5b902ef268a8d33e9b5c47fc687bcd6c5a7"
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
    node_arch = Hardware::CPU.intel? ? "x64" : "arm64"
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cdxgen/cdxgen-plugins-bin-#{os}-#{arch}/plugins"
    sqlite3_prebuilds = node_modules/"@appthreat/sqlite3/prebuilds"
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

    sqlite3_prebuilds.each_child do |dir|
      paths_to_remove << dir if dir.basename.to_s != "#{os}-#{node_arch}"
    end
    paths_to_remove << (sqlite3_prebuilds/"#{os}-#{node_arch}/@appthreat+sqlite3.musl.node") if OS.linux?
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