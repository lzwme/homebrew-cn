class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:trino.io"
  url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server440trino-server-440.tar.gz", using: :nounzip
  sha256 "770ac6fa9dff69cc7ec2c632b2b279b802556398c7a25561d6d20a3ed5f15729"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3a70d3944797e8e467fab9fd2cf8360e7ce41ce39615bd627a98d6112296511"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "trino-src" do
    url "https:github.comtrinodbtrinoarchiverefstags440.tar.gz", using: :nounzip
    sha256 "81100f96b73d97f385dfe450a190d809165ff816f37dcadb34c6df4d75fa2796"
  end

  resource "trino-cli" do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-cli440trino-cli-440-executable.jar"
    sha256 "15d726aa8a91ddd14bf7394355bbe84be05f3011feebb2b2669cc4e36db59eb3"
  end

  def install
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