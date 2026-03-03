class Twoping < Formula
  include Language::Python::Virtualenv

  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.6.tar.gz"
  sha256 "b678738716e9070d37af31ce12aff1709b22978f05059f194b71a1964829708f"
  license "MPL-2.0"
  head "https://github.com/rfinnie/2ping.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6210baa0212b0e3ac32c90590585882617d4172783eadba5e8dda0793f1bcbe"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources

    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    # Upstream removed the sample bash completion script in v4.6:
    # https://github.com/rfinnie/2ping/commit/e5f62bbc412b6f1bb14c4139a1dbcb97c32b5c81
    # Downstream guidance is tracked in:
    # https://github.com/rfinnie/2ping/issues/10
  end

  service do
    run [opt_bin/"2ping", "--listen", "--quiet"]
    keep_alive true
    require_root true
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    assert_match "OK 2PING", shell_output(
      "#{bin}/2ping --count=10 --interval=0.2 --port=-1 --interface-address=127.0.0.1 " \
      "--listen --nagios=1000,5%,1000,5% 127.0.0.1",
    )
  end
end