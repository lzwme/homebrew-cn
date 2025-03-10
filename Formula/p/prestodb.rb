class Prestodb < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:prestodb.io"
  url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-server0.291presto-server-0.291.tar.gz", using: :nounzip
  sha256 "257702209ddfcc49dd6764ab8ea959d441313f3b74bb9b86c45c9a8a63a0a691"
  license "Apache-2.0"

  # Upstream has said that we should check Maven for Presto version information
  # and the highest version found there is newest:
  # https:github.comprestodbprestoissues16200
  livecheck do
    url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1bc6a7c18c6d8b8cfa26f0b235c7d0b6e9706fe3d7a3feed66cede28b878bb39"
  end

  depends_on "openjdk@17"
  depends_on "python@3.13"

  resource "presto-cli" do
    url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-cli0.291presto-cli-0.291-executable.jar"
    sha256 "3919eb122ad7090364430b500478465024e6524c8399fbf54181e9ac4ebb176b"

    livecheck do
      formula :parent
    end
  end

  def install
    java_version = "17"
    odie "presto-cli resource needs to be updated" if version != resource("presto-cli").version

    # Manually extract tarball to avoid multiple copiesmoves of over 2GB of files
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "presto-server-#{version}.tar.gz"

    (libexec"etcnode.properties").write <<~EOS
      node.environment=production
      node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
      node.data-dir=#{var}prestodata
    EOS

    (libexec"etcjvm.config").write <<~EOS
      -server
      -Xmx16G
      -XX:+UseG1GC
      -XX:G1HeapRegionSize=32M
      -XX:+UseGCOverheadLimit
      -XX:+ExplicitGCInvokesConcurrent
      -XX:+HeapDumpOnOutOfMemoryError
      -XX:+ExitOnOutOfMemoryError
      -Djdk.attach.allowAttachSelf=true
    EOS

    (libexec"etcconfig.properties").write <<~EOS
      coordinator=true
      node-scheduler.include-coordinator=true
      http-server.http.port=8080
      query.max-memory=5GB
      query.max-memory-per-node=1GB
      discovery-server.enabled=true
      discovery.uri=http:localhost:8080
    EOS

    (libexec"etclog.properties").write "com.facebook.presto=INFO"

    (libexec"etccatalogjmx.properties").write "connector.name=jmx"

    rewrite_shebang detected_python_shebang, libexec"binlauncher.py"
    env = Language::Java.overridable_java_home_env(java_version)
    (bin"presto-server").write_env_script libexec"binlauncher", env

    resource("presto-cli").stage do
      libexec.install "presto-cli-#{version}-executable.jar"
      bin.write_jar_script(libexec"presto-cli-#{version}-executable.jar", "presto", java_version:)
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = (libexec"binprocname").children
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" }
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    rm_r libprocname_dirs
  end

  def post_install
    (var"prestodata").mkpath
  end

  def caveats
    <<~EOS
      Add connectors to #{opt_libexec}etccatalog. See:
      https:prestodb.iodocscurrentconnector.html
    EOS
  end

  service do
    run [opt_bin"presto-server", "run"]
    working_dir opt_libexec
  end

  test do
    port = free_port
    cp libexec"etcconfig.properties", testpath"config.properties"
    inreplace testpath"config.properties", "8080", port.to_s
    server = fork do
      exec bin"presto-server", "run", "--verbose",
                                       "--data-dir", testpath,
                                       "--config", testpath"config.properties"
    end
    sleep 60

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output(bin"presto --debug --server localhost:#{port} --execute '#{query}'")
    assert_match "\"active\"", output
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end