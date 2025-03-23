class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:trino.io"
  url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server474trino-server-474.tar.gz"
  sha256 "8b4c163690dbd76315bc9ae68a984d5120414d144e835705cef8109684fd3140"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "866ff462da8156013906cf8b425a5f7d43de791e9957aa2fc8255ade78cb878a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "866ff462da8156013906cf8b425a5f7d43de791e9957aa2fc8255ade78cb878a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "866ff462da8156013906cf8b425a5f7d43de791e9957aa2fc8255ade78cb878a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8996faae219d1bfc0fd434bd50a6d44d31df83b313a6e61933595a120b32e0dd"
    sha256 cellar: :any_skip_relocation, ventura:       "8996faae219d1bfc0fd434bd50a6d44d31df83b313a6e61933595a120b32e0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a8ea300230f87932df34a3ecf146f54798fb3c9f062d6f9b248465ba2bf917d"
  end

  depends_on "go" => :build
  depends_on "openjdk"

  resource "trino-src" do
    url "https:github.comtrinodbtrinoarchiverefstags474.tar.gz"
    sha256 "be73eac8dee94e3087c120fb99e8037b6eaabc6a7893ac0a3fa437c2342da9ef"

    livecheck do
      formula :parent
    end
  end

  resource "trino-cli" do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-cli474trino-cli-474-executable.jar"
    sha256 "f8d9152ef01a78dfa7eb98c805b6130c25047105913443046e000946d0c62fce"

    livecheck do
      formula :parent
    end
  end

  # `brew livecheck --autobump --resources trino` should show the launcher version which is found by
  # getting airbase version at https:github.comtrinodbtrinoblob#{version}pom.xml#L8 and then
  # dep.launcher.version at https:github.comairliftairbaseblob<airbase-version>airbasepom.xml#L225
  resource "launcher" do
    url "https:github.comairliftlauncherarchiverefstags303.tar.gz"
    sha256 "14e6ecbcbee3f0d24b9de1f7be6f3a220153ea17d3fc88d05bbb12292b3dd52c"

    livecheck do
      url "https:raw.githubusercontent.comtrinodbtrinorefstags#{LATEST_VERSION}pom.xml"
      regex(%r{<artifactId>airbase<artifactId>\s*<version>(\d+(?:\.\d+)*)<version>}i)
      strategy :page_match do |page, regex|
        airbase_version = page[regex, 1]
        next if airbase_version.blank?

        get_airbase_page = Homebrew::Livecheck::Strategy.page_content(
          "https:raw.githubusercontent.comairliftairbaserefstags#{airbase_version}airbasepom.xml",
        )
        next if get_airbase_page[:content].blank?

        get_airbase_page[:content][%r{<dep\.launcher\.version>(\d+(?:\.\d+)*)<dep\.launcher\.version>}i, 1]
      end
    end
  end

  resource "procname" do
    on_linux do
      url "https:github.comairliftprocnamearchivec75422ec5950861852570a90df56551991399d8c.tar.gz"
      sha256 "95b04f7525f041c1fa651af01dced18c4e9fb68684fb21a298684e56eee53f48"
    end
  end

  def install
    odie "trino-src resource needs to be updated" if version != resource("trino-src").version
    odie "trino-cli resource needs to be updated" if version != resource("trino-cli").version

    # Workaround for https:github.comairliftlauncherissues8
    inreplace "binlauncher", 'case "$(arch)" in', 'case "$(uname -m)" in' if OS.mac? && Hardware::CPU.intel?

    # Replace pre-build binaries
    rm_r(Dir["bin{darwin,linux}-*"])
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    platform_dir = buildpath"bin#{OS.kernel_name.downcase}-#{arch}"
    resource("launcher").stage do |r|
      ldflags = "-s -w -X launcherargs.Version=#{r.version}"
      system "go", "build", "-C", "srcmaingo", *std_go_args(ldflags:, output: platform_dir"launcher")
    end
    if OS.linux?
      resource("procname").stage do
        system "make"
        platform_dir.install "libprocname.so"
      end
    end

    libexec.install Dir["*"]
    libexec.install resource("trino-cli")
    bin.write_jar_script libexec"trino-cli-#{version}-executable.jar", "trino"
    (bin"trino-server").write_env_script libexec"binlauncher", Language::Java.overridable_java_home_env

    resource("trino-src").stage do
      (libexec"etc").install Dir["coredockerdefaultetc*"]
      inreplace libexec"etcnode.properties", "docker", tap.user.downcase
      inreplace libexec"etcnode.properties", "datatrino", var"trinodata"
      inreplace libexec"etcjvm.config", %r{^-agentpath:usrlibtrinobinlibjvmkill.so$\n}, ""
    end

    # Work around OpenJDK  Apple (FB12076992) issue causing crashes with brew-built OpenJDK.
    # TODO: May want to look into privilegessigning as this doesn't happen on casks like Temurin & Zulu
    #
    # Ref: https:github.comtrinodbtrinoissues18983#issuecomment-1794206475
    # Ref: https:bugs.openjdk.orgbrowseCODETOOLS-7903447
    (libexec"etcjvm.config").append_lines <<~CONFIG if OS.mac?
      # https:bugs.openjdk.orgbrowseCODETOOLS-7903447
      -Djol.skipHotspotSAAttach=true
    CONFIG
  end

  def post_install
    (var"trinodata").mkpath
  end

  service do
    run [opt_bin"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}trino --version")

    ENV["CATALOG_MANAGEMENT"] = "static"
    port = free_port
    cp libexec"etcconfig.properties", testpath"config.properties"
    inreplace testpath"config.properties", "8080", port.to_s
    server = spawn bin"trino-server", "run", "--verbose",
                                              "--data-dir", testpath,
                                              "--config", testpath"config.properties"
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output("#{bin}trino --debug --server localhost:#{port} --execute '#{query}'")
    assert_match '"active"', output
  ensure
    Process.kill("TERM", server)
    begin
      Process.wait(server)
    rescue Errno::ECHILD
      quiet_system "pkill", "-9", "-P", server.to_s
    end
  end
end