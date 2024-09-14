class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https:www.fail2ban.org"
  url "https:github.comfail2banfail2banarchiverefstags1.1.0.tar.gz"
  sha256 "474fcc25afdaf929c74329d1e4d24420caabeea1ef2e041a267ce19269570bae"
  license "GPL-2.0-or-later"
  revision 2
  head "https:github.comfail2banfail2ban.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c35f7c03fdc881d8629ffeb8bb7120021f5c2801651400beae934732da5f5ca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d091c51f21f9d594185598a9ca6d7845b429622eba307f0eef57a3b8b6e3c5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d091c51f21f9d594185598a9ca6d7845b429622eba307f0eef57a3b8b6e3c5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d091c51f21f9d594185598a9ca6d7845b429622eba307f0eef57a3b8b6e3c5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5c158d54cab237debb765bac1afbb9863c7ecd19ad7a37e1d1b6ed0cd06f430"
    sha256 cellar: :any_skip_relocation, ventura:        "b5c158d54cab237debb765bac1afbb9863c7ecd19ad7a37e1d1b6ed0cd06f430"
    sha256 cellar: :any_skip_relocation, monterey:       "b5c158d54cab237debb765bac1afbb9863c7ecd19ad7a37e1d1b6ed0cd06f430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c50360cfb4f6a2b5634347c45d934391ac64b3aa9a7f9e1c94168dbdafe6e9f"
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.12"

  # Drop distutils: https:github.comfail2banfail2banpull3728
  patch do
    url "https:github.comfail2banfail2bancommita763fbbdfd6486e372965b4009eb3fe5db346718.patch?full_index=1"
    sha256 "631ca7e59e21d4a9bbe6adf02d0b1ecc0fa33688d145eb5e736d961e0e55e4cd"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    Pathname.glob("configpaths-*.conf").reject do |pn|
      pn.fnmatch?("configpaths-common.conf") || pn.fnmatch?("configpaths-osx.conf")
    end.map(&:unlink)

    # Replace paths in config
    inreplace "configjail.conf", "before = paths-debian.conf", "before = paths-osx.conf"

    # Replace hardcoded paths
    inreplace_etc_var(Pathname.glob("config{action,filter}.d***").select(&:file?), audit_result: false)
    inreplace_etc_var(["configfail2ban.conf", "configpaths-common.conf", "docrun-rootless.txt"])
    inreplace_etc_var(Pathname.glob("fail2ban***").select(&:file?), audit_result: false)
    inreplace_etc_var(Pathname.glob("man*"), audit_result: false)

    # Update `data_files` from absolute to relative paths for wheel compatability and include doc files
    inreplace "setup.py" do |s|
      s.gsub! "etc", ".etc"
      s.gsub! "var", ".var"
      s.gsub! "usrsharedocfail2ban", ".sharedocfail2ban"
      s.gsub! "if os.path.exists('.varrun')", "if True"
      s.gsub! "platform_system in ('linux',", "platform_system in ('linux', 'darwin',"
    end

    system python3.opt_libexec"binpython", "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    # Fix symlink broken by python upgrades
    ln_sf python3.opt_libexec"binpython", bin"fail2ban-python"
    etc.install (prefix"etc").children

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
      You must enable any jails by editing:
        #{etc}fail2banjail.conf

      Other configuration files are in #{etc}fail2ban. See more instructions at
      https:github.comfail2banfail2banwikiProper-fail2ban-configuration.
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