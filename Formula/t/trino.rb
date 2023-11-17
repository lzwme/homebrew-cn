class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/432/trino-server-432.tar.gz", using: :nounzip
  sha256 "76fd07f89c269196196f9b92d287bc8ef189685383cc7400985ad2ff12e062f2"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17fe8aef45593faff9e12c3fabd049611433cf6d78bc480bd1a093ce5f0707b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17fe8aef45593faff9e12c3fabd049611433cf6d78bc480bd1a093ce5f0707b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17fe8aef45593faff9e12c3fabd049611433cf6d78bc480bd1a093ce5f0707b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "17fe8aef45593faff9e12c3fabd049611433cf6d78bc480bd1a093ce5f0707b0"
    sha256 cellar: :any_skip_relocation, ventura:        "17fe8aef45593faff9e12c3fabd049611433cf6d78bc480bd1a093ce5f0707b0"
    sha256 cellar: :any_skip_relocation, monterey:       "17fe8aef45593faff9e12c3fabd049611433cf6d78bc480bd1a093ce5f0707b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b9ba1e01994e92ada98cf31f253d17a4c91f558f4eecaba6307965e7e94be87"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "trino-src" do
    url "https://ghproxy.com/https://github.com/trinodb/trino/archive/refs/tags/432.tar.gz", using: :nounzip
    sha256 "dfa92f8210b7c0e222a7d0250866f194144cf7272761a0922ba65f3ee984b7b8"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/432/trino-cli-432-executable.jar"
    sha256 "83a581ad5463b475e658a6239c52b22edd8e53d87fd797c6ef002fb7e38d6d29"
  end

  def install
    # Manually extract tarball to avoid losing hardlinks which increases bottle
    # size from MBs to GBs. Remove once Homebrew is able to preserve hardlinks.
    # Ref: https://github.com/Homebrew/brew/pull/13154
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "trino-server-#{version}.tar.gz"

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
    # Remove when https://github.com/trinodb/trino/issues/8877 is fixed
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
    assert_match("432", shell_output("#{bin}/trino --version").strip)
    # A more complete test existed before but we removed it because it crashes macOS
    # https://github.com/Homebrew/homebrew-core/pull/153348
    # You can add it back when the following issue is fixed:
    # https://github.com/trinodb/trino/issues/18983#issuecomment-1794206475
    # https://bugs.openjdk.org/browse/CODETOOLS-7903447
  end
end