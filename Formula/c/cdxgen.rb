class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https:github.comCycloneDXcdxgen"
  url "https:registry.npmjs.org@cyclonedxcdxgen-cdxgen-11.4.1.tgz"
  sha256 "c3201f25a368d4bf546870710e4ad81a409f619d3d893c7b004eb8eee7ddcd1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab5f0add39aac762be8ca39714784ef5e8aa31bf6a525e760e3d9210a46e224b"
    sha256 cellar: :any,                 arm64_sonoma:  "eabafc22f0b1a25f7141393202b1c3a5307c7adb1f7cfa86a263830a76497eb5"
    sha256 cellar: :any,                 arm64_ventura: "a546cb5f6a03705dabff53ea9079f0484d17fde7db30247c7290ba254cd9263a"
    sha256 cellar: :any,                 ventura:       "b77efeb6bfc4d52c821ecec9605f677cff4bc829bc29a2e8954db6949b584e30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ede593c46065e79729f01c61844871ebac0d1d22714a349c93e76dde3e635033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99522066804a9cb561720d40c523360b5e46eedb63eaf6f5de9080365048ae2d"
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