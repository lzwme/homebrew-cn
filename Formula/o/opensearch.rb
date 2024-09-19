class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https:github.comopensearch-projectOpenSearch"
  url "https:github.comopensearch-projectOpenSearcharchiverefstags2.17.0.tar.gz"
  sha256 "6af45ea416cf72e08680726ef59f0379fcbfa889845fd2626c86d9ae8ebbd9c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3ec14eb26e1330288b9187999e92fd24bb57ca197bb04d9f36c24cdd3fc54e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489f45c48258b6a4e2892c4bc11dbcf740b4a82490e70ee42bd1c209a96b1378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6369e4b29a325a4c2dad440bd281c1bbdc08c6e0838a6dc0c92f99a495e74df0"
    sha256 cellar: :any_skip_relocation, sonoma:        "54d09deadd49d3ac1988c3ae596c0f84b4d086b1420aa69c6cddf27bbcbddc8e"
    sha256 cellar: :any_skip_relocation, ventura:       "d9edc7bcec7b521ce01003b7c7925ce656c2a2fe7492b87dac18041c5695dc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b66d042f32c6604bcf1ec127b79fe3bc26d4028c9733e62c66ff74acc4250d0"
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

    system bin"opensearch-plugin", "list"
  end
end