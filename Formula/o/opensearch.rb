class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https:github.comopensearch-projectOpenSearch"
  url "https:github.comopensearch-projectOpenSearcharchiverefstags3.1.0.tar.gz"
  sha256 "7f682d85fb82c2caa9fe6dff0a0c1769df0b5ed96b993ac8cdd6485f3d103fda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14c6a7df9cb6a0b2e732881a31b58b2e6a1d4e50de88d52f41cea2f3716d4a91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f55ca1cf8350cd32015660b57eeda81d97fba0725f05bf87e37f86365d5bd7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54acb7e61c007fdec2d9ce0af1626ad7e863ba8a104fade952e8bac3e906fd28"
    sha256 cellar: :any_skip_relocation, sonoma:        "9185ecf2cfc924b7676a2a3ce010433e54cc5de5beea7b01f2894da865a361e0"
    sha256 cellar: :any_skip_relocation, ventura:       "9028211903fe956ff64df4bfe8add34feb5e7eab65fe68dd0ce8ddd159c34d3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c69e89426b143739bbbc3b02430483f605d7d7a55062a1a69083b39874059505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc27344b4c320c2a3395ea5f72e5927154afd53ee31cb8ab4e6e602c5b41a732"
  end

  depends_on "gradle" => :build
  # Can be updated after https:github.comopensearch-projectOpenSearchpull18085 is released.
  depends_on "openjdk@21"

  def install
    platform = OS.kernel_name.downcase
    platform += "-arm64" if Hardware::CPU.arm?
    system "gradle", "-Dbuild.snapshot=false", ":distribution:archives:no-jdk-#{platform}-tar:assemble"

    mkdir "tar" do
      # Extract the package to the tar directory
      system "tar", "--strip-components=1", "-xf",
        Dir["..distributionarchivesno-jdk-#{platform}-tarbuilddistributionsopensearch-*.tar.gz"].first

      # Install into package directory
      libexec.install "bin", "lib", "modules", "agent"

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
    # Can be updated after https:github.comopensearch-projectOpenSearchpull18085 is released.
    bin.env_script_all_files(libexec"bin", JAVA_HOME: Formula["openjdk@21"].opt_prefix)
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
    spawn bin"opensearch", "-Ehttp.port=#{port}",
                            "-Epath.data=#{testpath}data",
                            "-Epath.logs=#{testpath}logs"
    sleep 60
    output = shell_output("curl -s -XGET localhost:#{port}")
    assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

    system bin"opensearch-plugin", "list"
  end
end