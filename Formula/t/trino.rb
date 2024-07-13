class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:trino.io"
  url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server452trino-server-452.tar.gz", using: :nounzip
  sha256 "66e09ab1453d2a107daf2406e00d0c580f19f3cbc1301dfe5342c1042cc8ed36"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ff203db87b8155a02e7962b7cde32955874facf1f0e04237a558c031780fb9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff203db87b8155a02e7962b7cde32955874facf1f0e04237a558c031780fb9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ff203db87b8155a02e7962b7cde32955874facf1f0e04237a558c031780fb9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ff203db87b8155a02e7962b7cde32955874facf1f0e04237a558c031780fb9f"
    sha256 cellar: :any_skip_relocation, ventura:        "0ff203db87b8155a02e7962b7cde32955874facf1f0e04237a558c031780fb9f"
    sha256 cellar: :any_skip_relocation, monterey:       "0ff203db87b8155a02e7962b7cde32955874facf1f0e04237a558c031780fb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e1520171c1230f89d88aaf2fe3d51af44c0a31c63953afc6a6f64106ba9a1b"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "trino-src" do
    url "https:github.comtrinodbtrinoarchiverefstags452.tar.gz", using: :nounzip
    sha256 "87079a0a1b15d290ffa66757c9fb47f28d859f3348a2b4ac97436811657ba51a"
  end

  resource "trino-cli" do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-cli452trino-cli-452-executable.jar"
    sha256 "5bfb5845a35f80eae57f0084dd19fb443feba481e2804248c7fd738fd27d89c1"
  end

  def install
    odie "trino-src resource needs to be updated" if version != resource("trino-src").version
    odie "trino-cli resource needs to be updated" if version != resource("trino-cli").version

    # Manually extract tarball to avoid losing hardlinks which increases bottle
    # size from MBs to GBs. Remove once Homebrew is able to preserve hardlinks.
    # Ref: https:github.comHomebrewbrewpull13154
    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xzf", "trino-server-#{version}.tar.gz"

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363plugintrino-hivesrctestresources<truncated>.snappy.orc.crc: Failed to restore metadata
    # Remove when https:github.comtrinodbtrinoissues8877 is fixed
    resource("trino-src").stage do |r|
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec"gnubin"
      system "tar", "-xzf", "trino-#{r.version}.tar.gz"
      (libexec"etc").install Dir["trino-#{r.version}coredockerdefaultetc*"]
      inreplace libexec"etcnode.properties", "docker", tap.user.downcase
      inreplace libexec"etcnode.properties", "datatrino", var"trinodata"
      inreplace libexec"etcjvm.config", %r{^-agentpath:usrlibtrinobinlibjvmkill.so$\n}, ""
    end

    rewrite_shebang detected_python_shebang, libexec"binlauncher.py"
    (bin"trino-server").write_env_script libexec"binlauncher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("binprocname*")
    # Keep the Linux-x86_64 directory to make bottles identical
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "Linux-x86_64" } if build.bottle?
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    libprocname_dirs.map(&:rmtree)
  end

  def post_install
    (var"trinodata").mkpath
  end

  service do
    run [opt_bin"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}trino --version")
    # A more complete test existed before but we removed it because it crashes macOS
    # https:github.comHomebrewhomebrew-corepull153348
    # You can add it back when the following issue is fixed:
    # https:github.comtrinodbtrinoissues18983#issuecomment-1794206475
    # https:bugs.openjdk.orgbrowseCODETOOLS-7903448
  end
end