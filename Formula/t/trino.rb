class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https:trino.io"
  url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server467trino-server-467.tar.gz", using: :nounzip
  sha256 "8cb2970e972f8ea9af9aa89ed7271f4ab73d61fda06f20d8c0a5d19e20a6d2be"
  license "Apache-2.0"

  livecheck do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-server"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47052b19fa59f77ef98d4e9da6d05960fac815c679418ec2c83c711d984d1fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47052b19fa59f77ef98d4e9da6d05960fac815c679418ec2c83c711d984d1fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f47052b19fa59f77ef98d4e9da6d05960fac815c679418ec2c83c711d984d1fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "42da783d20fefc5a20e6a439dc68933d6041cacdbd5f94caad427565b2844acb"
    sha256 cellar: :any_skip_relocation, ventura:       "42da783d20fefc5a20e6a439dc68933d6041cacdbd5f94caad427565b2844acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdafe3b615c88b0228e7361fedd4ad0bcb3503f36f98d6a28e8e5ebd546e97a1"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"

  uses_from_macos "python"

  resource "trino-src" do
    url "https:github.comtrinodbtrinoarchiverefstags467.tar.gz", using: :nounzip
    sha256 "707fdb557ad548b754cf0240d51b12b85d59c25cf1db39cbbe829ed462e8fa3d"
  end

  resource "trino-cli" do
    url "https:search.maven.orgremotecontent?filepath=iotrinotrino-cli467trino-cli-467-executable.jar"
    sha256 "ac7a83c63f12ca3e9525aa94f5168d7278c51ddcb34527691a3b4948a67be845"
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