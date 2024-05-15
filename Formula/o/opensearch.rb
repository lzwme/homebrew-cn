class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https:github.comopensearch-projectOpenSearch"
  url "https:github.comopensearch-projectOpenSearcharchiverefstags2.14.0.tar.gz"
  sha256 "72eab7e3882e3dd8d16aad39d077b46576ef583e267c6ccdfe3bffdd429ff6fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "345878a301683145046923da2f0beaa0c744967a45d1f8fd259b8850a929a8ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e71fbd162b50636fd51ce483328ec834a36335290100509665d4fe868bd5a7d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b014f05553bcde1af0748ae5cc269f3f690718d3d039ce3430d968c654ec82c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f40bdfa28b1cde1d37a6fdac304ceb30973937cde91af9d6438c350eea4e859"
    sha256 cellar: :any_skip_relocation, ventura:        "a808866fecd19cc269ea21c6a6b81451c43f6dc4cc5f9ead69aaba1afe921488"
    sha256 cellar: :any_skip_relocation, monterey:       "be09276341a0254fb6f38a38a3dcd14d0d721e0aeef503a8e6d0a03ad892d2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a637955582355be37605631ff1d0e604904cde85191192077480b98ae6ddedb"
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