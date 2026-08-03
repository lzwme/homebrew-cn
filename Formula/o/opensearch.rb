class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch.git",
      tag:      "3.7.0",
      revision: "72121f014083f9ca010fd5a7da83b2ec4886027f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b5eeb560c500ed4a00adeb0d207e225b1f831dca51ae3a3088f27118574947b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10aea76eb24a3fd118146355c5ce784f781770daaabb8069fcc03d7e681ef949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7b202991dd11c7be6313e150e69863e75a2ec44f2b170538c2ad6fd0521190"
    sha256 cellar: :any_skip_relocation, sonoma:        "b08a2a2446487d6a1b0e882e90acc0d78422e3eb922ac3a93eea37f1d5f0a04e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8da08e8e212dc8460418cda3ae51177c1d7088b1884f2cd2ecddf53ecd5e270c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68d8404995cd792441fae37cd6b62b04587a14c1a45d6306e7bfaaa03d9e39c"
  end

  # TODO: Use the vendored Gradle wrapper until its minor version matches Homebrew's `gradle`.
  depends_on "openjdk@25"

  def install
    platform = OS.kernel_name.downcase
    platform += "-arm64" if Hardware::CPU.arm?
    system "./gradlew", "-Dbuild.snapshot=false", ":distribution:archives:no-jdk-#{platform}-tar:assemble"

    mkdir "tar" do
      # Extract the package to the tar directory
      system "tar", "--strip-components=1", "-xf",
        Dir["../distribution/archives/no-jdk-#{platform}-tar/build/distributions/opensearch-*.tar.gz"].first

      # Install into package directory
      libexec.install "bin", "lib", "modules", "agent"

      # Set up Opensearch for local development:
      inreplace "config/opensearch.yml" do |s|
        # 1. Give the cluster a unique name
        s.gsub!(/#\s*cluster\.name: .*/, "cluster.name: opensearch_homebrew")

        # 2. Configure paths
        s.sub!(%r{#\s*path\.data: /path/to.+$}, "path.data: #{var}/lib/opensearch/")
        s.sub!(%r{#\s*path\.logs: /path/to.+$}, "path.logs: #{var}/log/opensearch/")
      end

      inreplace "config/jvm.options", %r{logs/gc.log}, "#{var}/log/opensearch/gc.log"

      # add placeholder to avoid removal of empty directory
      touch "config/jvm.options.d/.keepme"

      # Move config files into etc
      pkgetc.install Dir["config/*"]
    end

    inreplace libexec/"bin/opensearch-env",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"$OPENSEARCH_HOME\"/config; fi",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"#{etc}/opensearch\"; fi"

    bin.install libexec/"bin/opensearch",
                libexec/"bin/opensearch-keystore",
                libexec/"bin/opensearch-plugin",
                libexec/"bin/opensearch-shard"
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: formula_opt_prefix("openjdk@25"))

    (var/"lib/opensearch").mkpath
    (var/"log/opensearch").mkpath
    (var/"opensearch/plugins").mkpath
    (var/"opensearch/extensions").mkpath
    libexec.install_symlink pkgetc => "config"
    libexec.install_symlink var/"opensearch/plugins"
    libexec.install_symlink var/"opensearch/extensions"
  end

  post_install_steps do
    unless_path_exists "{{etc}}/opensearch/opensearch.keystore" do
      run "opensearch-keystore", args: ["create"], base: :bin
    end
  end

  def caveats
    <<~EOS
      Data:    #{var}/lib/opensearch/
      Logs:    #{var}/log/opensearch/opensearch_homebrew.log
      Plugins: #{var}/opensearch/plugins/
      Config:  #{etc}/opensearch/
    EOS
  end

  service do
    run opt_bin/"opensearch"
    working_dir var
    log_path var/"log/opensearch.log"
    error_log_path var/"log/opensearch.log"
  end

  test do
    port = free_port
    (testpath/"data").mkdir
    (testpath/"logs").mkdir
    pid = spawn bin/"opensearch", "-Ehttp.port=#{port}",
                            "-Epath.data=#{testpath}/data",
                            "-Epath.logs=#{testpath}/logs"
    sleep 30
    output = shell_output("curl -s -XGET localhost:#{port}/")
    assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

    system bin/"opensearch-plugin", "list"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end