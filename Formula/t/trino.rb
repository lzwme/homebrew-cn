class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:trino.io"
  url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server447trino-server-447.tar.gz", using: :nounzip
  sha256 "d4b2eee7efdc258017089ab92b464bdafe0c2e46cf352252542bad6f2c96b98d"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf10b56113c8562541cc0855221eb103b4ff255f3c6709a9384ac165c636af50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b0377fe44258a3d0e74073e271e0c34b8a24412e8bed36270308738e94280a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77718237b332be5b433aaca0cc77108a94916cc29bfd296e89ed880accdff2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c823fd1bba0716991605b8f5c616c9102ab6035037f705ee59a614e7efaecc1"
    sha256 cellar: :any_skip_relocation, ventura:        "cd22500aa09f3eb4a6d4e5f8e8d028d31f4f09390e03f4a5042b2d516d2cff0b"
    sha256 cellar: :any_skip_relocation, monterey:       "7c570daf94e99768b5dcb5c98cea701c1cc1f9d493fcb77a52fddb8534081cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf077627e2e951620da6b11853eb6cb52b5609e548086cc2f88af7742d4c23a"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "trino-src" do
    url "https:github.comtrinodbtrinoarchiverefstags447.tar.gz", using: :nounzip
    sha256 "ece238954733520ed893825399437ba833e56552ab79b224c74f2ffc7701a12d"
  end

  resource "trino-cli" do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-cli447trino-cli-447-executable.jar"
    sha256 "e033ddea0f4c57091fea08525a94e9c88140781585483087d5a84359f51a9c57"
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
    # https:bugs.openjdk.orgbrowseCODETOOLS-7903447
  end
end