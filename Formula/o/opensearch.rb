class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https:github.comopensearch-projectOpenSearch"
  url "https:github.comopensearch-projectOpenSearcharchiverefstags2.17.1.tar.gz"
  sha256 "d0b358b2aa30dae87babe67a9e352d7a2ab0e18ef3e9b7e025a6b9cb7fa752a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c5650170106a9b883b64fbef245b45590a9d2e16ea0afc92ff154bcb0b6e0dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7da75f92ea413daf858b25b5d0f123fa522200ed99cc2c23ad37013daa6b46d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbb7b4a04e46661f0f2e86e0e3407ebab9623d927170687dc3f6e33da082b154"
    sha256 cellar: :any_skip_relocation, sonoma:        "5efcdddef2a82de7435681c57f5c4ed68cf3aecc478474e6c8ba12d7dc803e0d"
    sha256 cellar: :any_skip_relocation, ventura:       "8c0d4f6fec1486659231b6efd854f40c2a704edad7f14382e0b1dd4cbd6f2acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "010f979f4837d8582827dba336cf1effddc385dbc0e131bc90aed3b67fb01b35"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  # Support JDK-23 (build time and runtime) --- may be removed in the next release v2.17.2
  patch do
    url "https:github.comopensearch-projectOpenSearchcommit1e7f6df79c7845ba04ecc4a05979db27965342c7.patch?full_index=1"
    sha256 "03076625edb55ad0f6f36f8721cb41709fbd732fcb6294f20f1481a6bcc64534"
  end

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

    system bin"opensearch-plugin", "list"
  end
end