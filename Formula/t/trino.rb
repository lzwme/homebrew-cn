class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:trino.io"
  url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server451trino-server-451.tar.gz", using: :nounzip
  sha256 "8db9f1d725da631f6be1c0f86639defc6186a094cda208717e9c13708b3d13b3"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8dbe46c9881990660dd44131e2598ff8120e21176fb604db28adf3307b8a516b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dbe46c9881990660dd44131e2598ff8120e21176fb604db28adf3307b8a516b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dbe46c9881990660dd44131e2598ff8120e21176fb604db28adf3307b8a516b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dbe46c9881990660dd44131e2598ff8120e21176fb604db28adf3307b8a516b"
    sha256 cellar: :any_skip_relocation, ventura:        "8dbe46c9881990660dd44131e2598ff8120e21176fb604db28adf3307b8a516b"
    sha256 cellar: :any_skip_relocation, monterey:       "8dbe46c9881990660dd44131e2598ff8120e21176fb604db28adf3307b8a516b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab05c15aac9c64249f4aece59a1b9d95736a1369aba78a10cae4569e3bec539c"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "trino-src" do
    url "https:github.comtrinodbtrinoarchiverefstags451.tar.gz", using: :nounzip
    sha256 "775ba0682de37bedbc057a6038177c5a0afc57b61a12a59062fb9a98d897b51e"
  end

  resource "trino-cli" do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-cli451trino-cli-451-executable.jar"
    sha256 "66dce89d8e19a149397de89bbb8e7dcc4793c6889eaac7ce1cd07ca0fc87ab54"
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