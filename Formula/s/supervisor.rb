class Supervisor < Formula
  include Language::Python::Virtualenv

  desc "Process Control System"
  homepage "http:supervisord.org"
  url "https:files.pythonhosted.orgpackagesce37517989b05849dd6eaa76c148f24517544704895830a50289cbbf53c7efb9supervisor-4.2.5.tar.gz"
  sha256 "34761bae1a23c58192281a5115fb07fbf22c9b0133c08166beffc70fed3ebc12"
  license "BSD-3-Clause-Modification"
  revision 1
  head "https:github.comSupervisorsupervisor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45cc3b60f2777d22cdac9c5c3d02c6d81ab4ad54e469e404889e685cb3ee6782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45cc3b60f2777d22cdac9c5c3d02c6d81ab4ad54e469e404889e685cb3ee6782"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45cc3b60f2777d22cdac9c5c3d02c6d81ab4ad54e469e404889e685cb3ee6782"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd5d653ec9ae1a0db2ddca2a58d549ea9c48d4c15be4a11eb71b3aa9e555e872"
    sha256 cellar: :any_skip_relocation, ventura:       "dd5d653ec9ae1a0db2ddca2a58d549ea9c48d4c15be4a11eb71b3aa9e555e872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f432821d07fd084494beb62d4f237950f1c9b640dabb6cb85a0d2fd8f6e0598"
  end

  depends_on "python@3.13"

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    inreplace buildpath"supervisorskelsample.conf" do |s|
      s.gsub! %r{tmpsupervisor\.sock}, var"runsupervisor.sock"
      s.gsub! %r{tmpsupervisord\.log}, var"logsupervisord.log"
      s.gsub! %r{tmpsupervisord\.pid}, var"runsupervisord.pid"
      s.gsub!(^;\[include\]$, "[include]")
      s.gsub! %r{^;files = relativedirectory\*\.ini$}, "files = #{etc}supervisor.d*.ini"
    end

    virtualenv_install_with_resources

    etc.install buildpath"supervisorskelsample.conf" => "supervisord.conf"
  end

  def post_install
    (var"run").mkpath
    (var"log").mkpath
    conf_warn = <<~EOS
      The default location for supervisor's config file is now:
        #{etc}supervisord.conf
      Please move your config file to this location and restart supervisor.
    EOS
    old_conf = etc"supervisord.ini"
    opoo conf_warn if old_conf.exist?
  end

  service do
    run [opt_bin"supervisord", "-c", etc"supervisord.conf", "--nodaemon"]
    keep_alive true
  end

  test do
    (testpath"sd.ini").write <<~EOS
      [unix_http_server]
      file=supervisor.sock

      [supervisord]
      loglevel=debug

      [rpcinterface:supervisor]
      supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

      [supervisorctl]
      serverurl=unix:supervisor.sock
    EOS

    begin
      pid = fork { exec bin"supervisord", "--nodaemon", "-c", "sd.ini" }
      sleep 1
      output = shell_output("#{bin}supervisorctl -c sd.ini version")
      assert_match version.to_s, output
    ensure
      Process.kill "TERM", pid
    end
  end
end