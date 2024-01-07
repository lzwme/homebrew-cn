class Prestodb < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:prestodb.io"
  url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-server0.285.1presto-server-0.285.1.tar.gz"
  sha256 "91acbf1c5589865be2bd9cab2dca6bce29abd35af301cedd67ecc19c6ebc894a"
  license "Apache-2.0"

  # Upstream has said that we should check Maven for Presto version information
  # and the highest version found there is newest:
  # https:github.comprestodbprestoissues16200
  livecheck do
    url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ccc86ca8cb7f162ee30a70311de8ceda80bd7901fc75d3ce2fa0ba1c98d61652"
  end

  # https:github.comprestodbprestoissues17146
  depends_on arch: :x86_64
  depends_on "openjdk@11"
  depends_on "python@3.12"

  resource "presto-cli" do
    url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-cli0.285.1presto-cli-0.285.1-executable.jar"
    sha256 "3f94310e7e5b4aea657004d2c549a591f3ce6e26224ab806f2ea02c1e29c3f3d"
  end

  def install
    libexec.install Dir["*"]

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
    env = Language::Java.overridable_java_home_env("11")
    env["PATH"] = "$JAVA_HOMEbin:$PATH"
    (bin"presto-server").write_env_script libexec"binlauncher", env

    resource("presto-cli").stage do
      libexec.install "presto-cli-#{version}-executable.jar"
      bin.write_jar_script libexec"presto-cli-#{version}-executable.jar", "presto", java_version: "11"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("binprocname*")
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" }
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    libprocname_dirs.map(&:rmtree)
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
    sleep 30

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output(bin"presto --debug --server localhost:#{port} --execute '#{query}'")
    assert_match "\"active\"", output
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end