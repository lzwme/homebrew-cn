class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:trino.io"
  url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server450trino-server-450.tar.gz", using: :nounzip
  sha256 "515156df19de8acb934026e252263b90b158d9c79fdbf6b28b72681e76a39be0"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e187a86c3204ab815633a0ca23f57223b5de37768ec49d204ee31f082e6f7c62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e187a86c3204ab815633a0ca23f57223b5de37768ec49d204ee31f082e6f7c62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e187a86c3204ab815633a0ca23f57223b5de37768ec49d204ee31f082e6f7c62"
    sha256 cellar: :any_skip_relocation, sonoma:         "e187a86c3204ab815633a0ca23f57223b5de37768ec49d204ee31f082e6f7c62"
    sha256 cellar: :any_skip_relocation, ventura:        "e187a86c3204ab815633a0ca23f57223b5de37768ec49d204ee31f082e6f7c62"
    sha256 cellar: :any_skip_relocation, monterey:       "e187a86c3204ab815633a0ca23f57223b5de37768ec49d204ee31f082e6f7c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b4f11a6ae43b48fe10f31bfe5988022ce0e5b3f5ddc13b5475ac50f9d78acd"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "trino-src" do
    url "https:github.comtrinodbtrinoarchiverefstags450.tar.gz", using: :nounzip
    sha256 "459d33484eeffda9489f9f5d5b3ac4b698f27a2894e28cb4dc28f1c47870fd80"
  end

  resource "trino-cli" do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-cli450trino-cli-450-executable.jar"
    sha256 "d20c89e9e151a06cd4cd83c9332cfe614603bf807c5e7a9083f092f8fbda1836"
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