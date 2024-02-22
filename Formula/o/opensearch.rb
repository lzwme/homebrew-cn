class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https:github.comopensearch-projectOpenSearch"
  url "https:github.comopensearch-projectOpenSearcharchiverefstags2.12.0.tar.gz"
  sha256 "224c7e6a2031eef33c64e09ba846dcef2dca5bd4643fda6bc3e300d30b8d0cc3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "702f8db7156072378c1771e782cde9219ac77ddaaba5e01536be6254465d82c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e05564f487e03e34758c8b6b9f2aac62a937f61e5e69d3bc0eef3db023c1d98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a903802576164a67789ec17e0ec1e3271347c140702680526bffc013aeb1734"
    sha256 cellar: :any_skip_relocation, sonoma:         "6204376da742af8954d2b24ee11a66aebbc2dd4a9ad2ac8fc5bc68fcac404d34"
    sha256 cellar: :any_skip_relocation, ventura:        "caf5ef8c83996071d6d1b6f1f7e28ff56a5f3d5a8a5943c52c23462c3f2c387e"
    sha256 cellar: :any_skip_relocation, monterey:       "b52066c7a345fe1f35b65f9f8d9b1f998ad8410f4f30e97d99cfa443250fa49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70f85bb3156055015a14cd1d474c8caff1e25d599795673369fa26884de0240d"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    platform = OS.kernel_name.downcase
    platform += "-arm64" if Hardware::CPU.arm?
    system "gradle", "-Dbuild.snapshot=false", ":distribution:archives:no-jdk-#{platform}-tar:assemble"

    mkdir "tar" do
      # Extract the package to the tar directory
      system "tar", "--strip-components=1", "-xf",
        Dir["..distributionarchivesno-jdk-#{platform}-tarbuilddistributionsopensearch-*.tar.gz"].first

      # Install into package directory
      libexec.install "bin", "lib", "modules"

      # Set up Opensearch for local development:
      inreplace "configopensearch.yml" do |s|
        # 1. Give the cluster a unique name
        s.gsub!(#\s*cluster\.name: .*, "cluster.name: opensearch_homebrew")

        # 2. Configure paths
        s.sub!(%r{#\s*path\.data: pathto.+$}, "path.data: #{var}libopensearch")
        s.sub!(%r{#\s*path\.logs: pathto.+$}, "path.logs: #{var}logopensearch")
      end

      inreplace "configjvm.options", %r{logsgc.log}, "#{var}logopensearchgc.log"

      # add placeholder to avoid removal of empty directory
      touch "configjvm.options.d.keepme"

      # Move config files into etc
      (etc"opensearch").install Dir["config*"]
    end

    inreplace libexec"binopensearch-env",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"$OPENSEARCH_HOME\"config; fi",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"#{etc}opensearch\"; fi"

    bin.install libexec"binopensearch",
                libexec"binopensearch-keystore",
                libexec"binopensearch-plugin",
                libexec"binopensearch-shard"
    bin.env_script_all_files(libexec"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  def post_install
    # Make sure runtime directories exist
    (var"libopensearch").mkpath
    (var"logopensearch").mkpath
    ln_s etc"opensearch", libexec"config" unless (libexec"config").exist?
    (var"opensearchplugins").mkpath
    ln_s var"opensearchplugins", libexec"plugins" unless (libexec"plugins").exist?
    (var"opensearchextensions").mkpath
    ln_s var"opensearchextensions", libexec"extensions" unless (libexec"extensions").exist?
    # fix test not being able to create keystore because of sandbox permissions
    system bin"opensearch-keystore", "create" unless (etc"opensearchopensearch.keystore").exist?
  end

  def caveats
    <<~EOS
      Data:    #{var}libopensearch
      Logs:    #{var}logopensearchopensearch_homebrew.log
      Plugins: #{var}opensearchplugins
      Config:  #{etc}opensearch
    EOS
  end

  service do
    run opt_bin"opensearch"
    working_dir var
    log_path var"logopensearch.log"
    error_log_path var"logopensearch.log"
  end

  test do
    port = free_port
    (testpath"data").mkdir
    (testpath"logs").mkdir
    fork do
      exec bin"opensearch", "-Ehttp.port=#{port}",
                             "-Epath.data=#{testpath}data",
                             "-Epath.logs=#{testpath}logs"
    end
    sleep 60
    output = shell_output("curl -s -XGET localhost:#{port}")
    assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

    system "#{bin}opensearch-plugin", "list"
  end
end