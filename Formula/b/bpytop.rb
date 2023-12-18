class Bpytop < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "LinuxOSXFreeBSD resource monitor"
  homepage "https:github.comaristocratosbpytop"
  url "https:github.comaristocratosbpytoparchiverefstagsv1.0.68.tar.gz"
  sha256 "3a936f8899efb66246e82bbcab33249bf94aabcefbe410e56f045a1ce3c9949f"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b4bb40e691ad83c8a37878d4927c4c4061d717d7c76badb196b8bb7f88f1c33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b4bb40e691ad83c8a37878d4927c4c4061d717d7c76badb196b8bb7f88f1c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b4bb40e691ad83c8a37878d4927c4c4061d717d7c76badb196b8bb7f88f1c33"
    sha256 cellar: :any_skip_relocation, sonoma:         "76b6191acb3c6d2c2745c557fd492aa44b6921e84427e00ca879e09ec652b9c9"
    sha256 cellar: :any_skip_relocation, ventura:        "76b6191acb3c6d2c2745c557fd492aa44b6921e84427e00ca879e09ec652b9c9"
    sha256 cellar: :any_skip_relocation, monterey:       "76b6191acb3c6d2c2745c557fd492aa44b6921e84427e00ca879e09ec652b9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8811adf8219ded4489100cb8f0aed862a97e0861f7bd179a24c87b3eabc4f4"
  end

  depends_on "python-psutil"
  depends_on "python@3.12"

  on_macos do
    depends_on "osx-cpu-temp"
  end

  # Tolerate SMC error from osx-cpu-temp
  # https:github.comaristocratosbpytoppull405
  patch do
    url "https:github.comaristocratosbpytopcommit5634526721b1bc98dc7a7003801cdf99686419ed.patch?full_index=1"
    sha256 "0158252936cfd1adcbe5e664f641a0c2bb6093270bedf4282cf5c7ff49a7d238"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "themes"

    # Replace shebang with virtualenv python
    rw_info = python_shebang_rewrite_info("#{libexec}binpython")
    rewrite_shebang rw_info, bin"bpytop"
  end

  test do
    config = (testpath".configbpytop")
    mkdir config"themes"
    # Disable cpu_freq on arm due to missing support: https:github.comgiampaolopsutilissues1892
    (config"bpytop.conf").write <<~EOS
      #? Config file for bpytop v. #{version}

      update_ms=2000
      log_level=DEBUG
      show_cpu_freq=#{!Hardware::CPU.arm?}
    EOS

    require "pty"
    require "ioconsole"

    r, w, pid = PTY.spawn("#{bin}bpytop")
    r.winsize = [80, 130]
    sleep 5
    w.write "\cC"

    log = (config"error.log").read
    assert_match "bpytop version #{version} started with pid #{pid}", log
    refute_match(ERROR:, log)
  ensure
    Process.kill("TERM", pid)
  end
end