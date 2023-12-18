class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https:github.comopensearch-projectOpenSearch"
  url "https:github.comopensearch-projectOpenSearcharchiverefstags2.11.1.tar.gz"
  sha256 "0c64658238f3a7051c01445325ec960bb176481399cb96490ebc5ab62459e4bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6460b8b239b4c23c604365eac8a4688c2cd59df5e20484477bf14ac1250e55cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e223cb52fe02990a0f661c72668bfc7b20d9a4cb9e421441811676aa438e41b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b69ed94efdaadb0113aed6dce92e7ac984a7817f56526b378fd0cb4ba0bce51"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dd9544e18326df22eeddb8ebbc107c128580cef7d8755827cab204238bfb6e8"
    sha256 cellar: :any_skip_relocation, ventura:        "cc866b6ffab2c4ea3c6f082403c9a5ee46767e532af3bb3cd7287ec02e388cea"
    sha256 cellar: :any_skip_relocation, monterey:       "ec44626ed3da29e7f94048135eb0b9dbc4201e29c6fd63eeb4033cd035212290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a013a63b67efe171e236b7134f85f48b28f1db247de75e0071cf3b382bf05ccc"
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