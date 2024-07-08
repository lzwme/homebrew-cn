class Prestodb < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:prestodb.io"
  url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-server0.288presto-server-0.288.tar.gz"
  sha256 "138761fa376567f5a40e3bbd252f98f15ceb677f3d0b454417c9ed49ae6b48a3"
  license "Apache-2.0"

  # Upstream has said that we should check Maven for Presto version information
  # and the highest version found there is newest:
  # https:github.comprestodbprestoissues16200
  livecheck do
    url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "6be6f0b4e0e79a303b7c2ab82f0c8a777a1c62ff589c44fe95f0f5f558af0d0f"
    sha256 cellar: :any_skip_relocation, ventura:      "6be6f0b4e0e79a303b7c2ab82f0c8a777a1c62ff589c44fe95f0f5f558af0d0f"
    sha256 cellar: :any_skip_relocation, monterey:     "6be6f0b4e0e79a303b7c2ab82f0c8a777a1c62ff589c44fe95f0f5f558af0d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d0e4dad455ed75323fab0e830b2319ade02878688a678b2b7bb78650248e5533"
  end

  # https:github.comprestodbprestoissues17146
  depends_on arch: :x86_64
  depends_on "openjdk@11"
  depends_on "python@3.12"

  resource "presto-cli" do
    url "https:search.maven.orgremotecontent?filepath=comfacebookprestopresto-cli0.288presto-cli-0.288-executable.jar"
    sha256 "2fd64558d65070786c2032656100eba82ebc7d69173feb0743f6beedbf26c555"
  end

  def install
    odie "presto-cli resource needs to be updated" if version != resource("presto-cli").version

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
    sleep 45

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output(bin"presto --debug --server localhost:#{port} --execute '#{query}'")
    assert_match "\"active\"", output
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end