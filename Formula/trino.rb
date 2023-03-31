class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/411/trino-server-411.tar.gz", using: :nounzip
  sha256 "24e6ddbc257a575ae1e6e097c5bbbb06dcf879640500530e67f461e6effd104f"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b34b4ca41e3262f752fc1dc336b1746ffa83371a3a96fd66b7ddd9c973587d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b34b4ca41e3262f752fc1dc336b1746ffa83371a3a96fd66b7ddd9c973587d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b34b4ca41e3262f752fc1dc336b1746ffa83371a3a96fd66b7ddd9c973587d9"
    sha256 cellar: :any_skip_relocation, ventura:        "1b34b4ca41e3262f752fc1dc336b1746ffa83371a3a96fd66b7ddd9c973587d9"
    sha256 cellar: :any_skip_relocation, monterey:       "1b34b4ca41e3262f752fc1dc336b1746ffa83371a3a96fd66b7ddd9c973587d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b34b4ca41e3262f752fc1dc336b1746ffa83371a3a96fd66b7ddd9c973587d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b10e3a8a7a0910d967f99a302718d7d4e0d8a6c01b878e34179b55e156cd2a7"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.11"

  resource "trino-src" do
    url "https://ghproxy.com/https://github.com/trinodb/trino/archive/refs/tags/411.tar.gz", using: :nounzip
    sha256 "267b53bf2f5962f2449fe815aae6c5d9d3bec254d962c80d7c8cb9a9f5f474c3"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/411/trino-cli-411-executable.jar"
    sha256 "f1fb29ed254a99ee9da78614ae85eb0ba2604dc204b17ec3eba9ed06ca56c6ce"
  end

  def install
    # Manually extract tarball to avoid losing hardlinks which increases bottle
    # size from MBs to GBs. Remove once Homebrew is able to preserve hardlinks.
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "trino-server-#{version}.tar.gz"

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
    resource("trino-src").stage do |r|
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
      system "tar", "-xzf", "trino-#{r.version}.tar.gz"
      (libexec/"etc").install Dir["trino-#{r.version}/core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
      inreplace libexec/"etc/jvm.config", %r{^-agentpath:/usr/lib/trino/bin/libjvmkill.so$\n}, ""
    end

    rewrite_shebang detected_python_shebang, libexec/"bin/launcher.py"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("bin/procname/*")
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" } if build.bottle?
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    libprocname_dirs.map(&:rmtree)
  end

  def post_install
    (var/"trino/data").mkpath
  end

  service do
    run [opt_bin/"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    port = free_port
    cp libexec/"etc/config.properties", testpath/"config.properties"
    inreplace testpath/"config.properties", "8080", port.to_s
    server = fork do
      exec bin/"trino-server", "run", "--verbose",
                                      "--data-dir", testpath,
                                      "--config", testpath/"config.properties"
    end
    sleep 30

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output(bin/"trino --debug --server localhost:#{port} --execute '#{query}'")
    assert_match "\"active\"", output
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end