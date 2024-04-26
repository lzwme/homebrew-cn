class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https:www.fail2ban.org"
  url "https:github.comfail2banfail2banarchiverefstags1.1.0.tar.gz"
  sha256 "474fcc25afdaf929c74329d1e4d24420caabeea1ef2e041a267ce19269570bae"
  license "GPL-2.0-or-later"
  head "https:github.comfail2banfail2ban.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91d045d27090b2fbb804b2a2664113a05994b95b448fecbe0fd510d179aa0575"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91d045d27090b2fbb804b2a2664113a05994b95b448fecbe0fd510d179aa0575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91d045d27090b2fbb804b2a2664113a05994b95b448fecbe0fd510d179aa0575"
    sha256 cellar: :any_skip_relocation, sonoma:         "02690c016600f89a6fd2ef1db64e02c8afee903662c033674d2153e0a3642e31"
    sha256 cellar: :any_skip_relocation, ventura:        "02690c016600f89a6fd2ef1db64e02c8afee903662c033674d2153e0a3642e31"
    sha256 cellar: :any_skip_relocation, monterey:       "02690c016600f89a6fd2ef1db64e02c8afee903662c033674d2153e0a3642e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17696ca92925114343ba483955efa4c34b5dacdec5b242f95c20712a7e3dc550"
  end

  depends_on "python-setuptools" => :build
  depends_on "sphinx-doc" => :build
  depends_on "python@3.12"

  def install
    ENV["PYTHON"] = python3 = "python3.12"

    Pathname.glob("configpaths-*.conf").reject do |pn|
      pn.fnmatch?("configpaths-common.conf") || pn.fnmatch?("configpaths-osx.conf")
    end.map(&:unlink)

    # Replace paths in config
    inreplace "configjail.conf", "before = paths-debian.conf", "before = paths-osx.conf"

    # Replace hardcoded paths
    inreplace_etc_var("setup.py")
    inreplace_etc_var(Pathname.glob("config{action,filter}.d***").select(&:file?), audit_result: false)
    inreplace_etc_var(["configfail2ban.conf", "configpaths-common.conf", "docrun-rootless.txt"])
    inreplace_etc_var(Pathname.glob("fail2ban***").select(&:file?), audit_result: false)
    inreplace_etc_var(Pathname.glob("man*"), audit_result: false)

    # Fix doc compilation
    inreplace "setup.py", "usrsharedocfail2ban", doc
    inreplace "setup.py", "if os.path.exists('#{var}run')", "if True"
    inreplace "setup.py", "platform_system in ('linux',", "platform_system in ('linux', 'darwin',"

    system python3, *Language::Python.setup_install_args(prefix, python3), "--without-tests"

    # Install docs
    system "make", "-C", "doc", "dirhtml", "SPHINXBUILD=sphinx-build"
    doc.install "docbuilddirhtml"
    man1.install Pathname.glob("man*.1")
    man5.install "manjail.conf.5"

    # Install into `bash-completion@2` path as not compatible with `bash-completion`
    (share"bash-completioncompletions").install "filesbash-completion" => "fail2ban"
  end

  def inreplace_etc_var(targets, audit_result: true)
    inreplace targets do |s|
      s.gsub! %r{etc}, etc, audit_result
      s.gsub! %r{var}, var, audit_result
    end
  end

  def post_install
    (etc"fail2ban").mkpath
    (var"runfail2ban").mkpath
  end

  def caveats
    <<~EOS
      Before using Fail2Ban for the first time you should edit the jail
      configuration and enable the jails that you want to use, for instance
      ssh-ipfw. Also, make sure that they point to the correct configuration
      path. I.e. on Mountain Lion the sshd logfile should point to
      varlogsystem.log.

        * #{etc}fail2banjail.conf

      The Fail2Ban wiki has two pages with instructions for macOS Server that
      describes how to set up the Jails for the standard macOS Server
      services for the respective releases.

        10.4: https:www.fail2ban.orgwikiindex.phpHOWTO_Mac_OS_X_Server_(10.4)
        10.5: https:www.fail2ban.orgwikiindex.phpHOWTO_Mac_OS_X_Server_(10.5)

      Please do not forget to update your configuration files.
      They are in #{etc}fail2ban.
    EOS
  end

  service do
    run [opt_bin"fail2ban-client", "-x", "start"]
    require_root true
  end

  test do
    system bin"fail2ban-client", "--test"

    (testpath"test.log").write <<~EOS
      Jan 31 11:59:59 [sshd] error: PAM: Authentication failure for test from 127.0.0.1
    EOS
    system bin"fail2ban-regex", "test.log", "sshd"
  end
end