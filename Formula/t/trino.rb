class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:trino.io"
  url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server470trino-server-470.tar.gz", using: :nounzip
  sha256 "16618db7c176d6c687f5782b97ec49c4a7beeab8f1f3edbd3f2c7b79d0b014ca"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1b9f36ff27b4bc879822a307ec1d7350ef2f90403c98f13ddbe291dda3eb9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec1b9f36ff27b4bc879822a307ec1d7350ef2f90403c98f13ddbe291dda3eb9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec1b9f36ff27b4bc879822a307ec1d7350ef2f90403c98f13ddbe291dda3eb9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ef8a2037980a5c013d5a1315fb7d264cc8633c189369f4d81056d04458946da"
    sha256 cellar: :any_skip_relocation, ventura:       "7ef8a2037980a5c013d5a1315fb7d264cc8633c189369f4d81056d04458946da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62360a7519b7481b8bece0ad260ed873a4d5fe31fcd5adce38e1e9a232f80276"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"

  uses_from_macos "python"

  resource "trino-src" do
    url "https:github.comtrinodbtrinoarchiverefstags470.tar.gz", using: :nounzip
    sha256 "e9989b2734dccd4c7900ccc9b96e7ef37ab3cf0368fb4be3734165442e89f1a5"

    livecheck do
      formula :parent
    end
  end

  resource "trino-cli" do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-cli470trino-cli-470-executable.jar"
    sha256 "694648f9906b43b308c6b2e529723231047feda6add186ab1eb0389516824d55"

    livecheck do
      formula :parent
    end
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

    rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec"binlauncher.py"
    (bin"trino-server").write_env_script libexec"binlauncher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    launcher_dirs = libexec.glob("bin{darwin,linux}-*")
    # Keep the linux-amd64 directory to make bottles identical
    launcher_dirs.reject! { |dir| dir.basename.to_s == "linux-amd64" } if build.bottle?
    launcher_dirs.reject! do |dir|
      dir.basename.to_s == "#{OS.kernel_name.downcase}-#{Hardware::CPU.intel? ? "amd64" : "arm64"}"
    end
    rm_r launcher_dirs
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