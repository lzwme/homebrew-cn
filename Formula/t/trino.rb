class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://ghfast.top/https://github.com/trinodb/trino/releases/download/483/trino-server-483.tar.gz"
  sha256 "4f3978428f26f36398c94b85a3e03b5301394919c8a4271b497b0fcd1698d0cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21f595da51f8f78b4677f2e7a6d0603d301fb33bbf723ca95ea8f3d38c623b82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21f595da51f8f78b4677f2e7a6d0603d301fb33bbf723ca95ea8f3d38c623b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21f595da51f8f78b4677f2e7a6d0603d301fb33bbf723ca95ea8f3d38c623b82"
    sha256 cellar: :any,                 arm64_linux:       "a052212f4102b9aef761b6cefc429224fa6ce318458e329839ab2de828f54019"
    sha256 cellar: :any,                 x86_64_linux:      "dfc19202770e99b7af5a2d334b1b5210e8b1e00f4274ee7fb5bfbd4b60f7d4e7"
  end

  depends_on "go" => :build
  # TODO: Try `openjdk` again once the `launcher` resource reaches 321, which adds JDK 27 flags
  depends_on "openjdk@25"

  resource "trino-src" do
    url "https://ghfast.top/https://github.com/trinodb/trino/archive/refs/tags/483.tar.gz"
    sha256 "3f0df83eb2621e30e76146cb5be0408a0d02db3e22d718d5d33009ef2e602d39"

    livecheck do
      formula :parent
    end
  end

  resource "trino-cli" do
    url "https://ghfast.top/https://github.com/trinodb/trino/releases/download/483/trino-cli-483"
    sha256 "182a1daca97bd14e7aa9b25cb62c6d0fd96fa80313e5431ac91da3184cebb601"

    livecheck do
      formula :parent
    end
  end

  # `brew livecheck --autobump --resources trino` should show the launcher version which is found by
  # getting airbase version at https://github.com/trinodb/trino/blob/#{version}/pom.xml#L8 and then
  # dep.launcher.version at https://github.com/airlift/airbase/blob/<airbase-version>/airbase/pom.xml#L225
  resource "launcher" do
    url "https://ghfast.top/https://github.com/airlift/launcher/archive/refs/tags/318.tar.gz"
    sha256 "b9293b91a04578caa67018dfb8eba6c6fd52f709e3a765e9d74a7e9027c90afd"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/trinodb/trino/refs/tags/#{LATEST_VERSION}/pom.xml"
      regex(%r{<artifactId>airbase</artifactId>\s*<version>(\d+(?:\.\d+)*)</version>}i)
      strategy :page_match do |page, regex|
        airbase_version = page[regex, 1]
        next if airbase_version.blank?

        get_airbase_page = Homebrew::Livecheck::Strategy.page_content(
          "https://ghfast.top/https://raw.githubusercontent.com/airlift/airbase/refs/tags/#{airbase_version}/airbase/pom.xml",
        )
        next if get_airbase_page[:content].blank?

        get_airbase_page[:content][%r{<dep\.launcher\.version>(\d+(?:\.\d+)*)</dep\.launcher\.version>}i, 1]
      end
    end
  end

  resource "procname" do
    on_linux do
      url "https://ghfast.top/https://github.com/airlift/procname/archive/c75422ec5950861852570a90df56551991399d8c.tar.gz"
      sha256 "95b04f7525f041c1fa651af01dced18c4e9fb68684fb21a298684e56eee53f48"
    end
  end

  def install
    odie "trino-src resource needs to be updated" if version != resource("trino-src").version
    odie "trino-cli resource needs to be updated" if version != resource("trino-cli").version

    # Workaround for https://github.com/airlift/launcher/issues/8
    inreplace "bin/launcher", 'case "$(arch)" in', 'case "$(uname -m)" in' if OS.mac? && Hardware::CPU.intel?

    # Replace pre-build binaries
    rm_r(Dir["bin/{darwin,linux}-*"])
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    platform_dir = buildpath/"bin/#{OS.kernel_name.downcase}-#{arch}"
    resource("launcher").stage do |r|
      ldflags = "-X launcher/args.Version=#{r.version}"
      system "go", "build", "-C", "src/main/go", *std_go_args(ldflags:, output: platform_dir/"launcher")
    end
    if OS.linux?
      resource("procname").stage do
        system "make"
        platform_dir.install "libprocname.so"
      end
    end

    libexec.install Dir["*"]
    libexec.install resource("trino-cli")
    bin.write_jar_script libexec/"trino-cli-#{version}", "trino", java_version: "25"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env("25")

    resource("trino-src").stage do
      (libexec/"etc").install Dir["core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
      inreplace libexec/"etc/jvm.config", %r{^-agentpath:/usr/lib/trino/bin/libjvmkill.so$\n}, ""
    end

    # Work around OpenJDK / Apple (FB12076992) issue causing crashes with brew-built OpenJDK.
    # TODO: May want to look into privileges/signing as this doesn't happen on casks like Temurin & Zulu
    #
    # Ref: https://github.com/trinodb/trino/issues/18983#issuecomment-1794206475
    # Ref: https://bugs.openjdk.org/browse/CODETOOLS-7903447
    (libexec/"etc/jvm.config").append_lines <<~CONFIG if OS.mac?
      # https://bugs.openjdk.org/browse/CODETOOLS-7903447
      -Djol.skipHotspotSAAttach=true
    CONFIG

    (var/"trino/data").mkpath
  end

  service do
    run [opt_bin/"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trino --version")

    ENV["CATALOG_MANAGEMENT"] = "static"
    port = free_port

    cp libexec/"etc/config.properties", testpath/"config.properties"
    inreplace testpath/"config.properties", "8080", port.to_s
    (testpath/"config.properties").append_lines "http-server.http.port=#{port}"

    server = spawn bin/"trino-server", "run", "--verbose",
                                              "--data-dir", testpath,
                                              "--config", testpath/"config.properties"
    sleep 30

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output("#{bin}/trino --debug --server localhost:#{port} --execute '#{query}'")
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