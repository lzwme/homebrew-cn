class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/d6/ac/fb40368ff37fbdd00d041e241cc0d7a50cdac7bc6ae54dcb9f1349acdde6/xxh-xxh-0.8.14.tar.gz"
  sha256 "7904c35efdff0a6f50f76b30879d3fbfe726cc765db47a1306ab2f19c03fdfae"
  license "BSD-2-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "923abfd2d054fbfe70eb2e7a38ab8572730bc25bea1101f81fd238015f92cdf2"
    sha256 cellar: :any, arm64_tahoe:       "bbd88ea9a7e45d7ef0311cd04e1ee522f616c182fb4b6c5e50fc063e97e3d727"
    sha256 cellar: :any, arm64_sequoia:     "22c559c25b18d828a505323f020f6433b996e42f99e31084b90b6fe2c6c17d68"
    sha256 cellar: :any, arm64_linux:       "dba58e415e8bd4c41eb30a26ae6dcc076890e0b46d73afab3b7b1e35b05562c2"
    sha256 cellar: :any, x86_64_linux:      "6d3c717281bc03fb6df9f22554728dbe580f07a7cc99d7634b49e433c629d42a"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xxh --version")

    (testpath/"config.xxhc").write <<~YAML
      hosts:
        test.localhost:
          -o: HostName=127.0.0.1
          +s: xxh-shell-zsh
    YAML
    begin
      port = free_port
      server = TCPServer.new(port)
      server_pid = fork do
        msg = server.accept.gets
        server.close
        assert_match "SSH", msg
      end

      stdout, stderr, = Open3.capture3(
        bin/"xxh", "test.localhost",
        "-p", port.to_s,
        "+xc", testpath/"config.xxhc",
        "+v"
      )

      argv = stdout.lines.grep(/^Final arguments list:/).first.split(":").second
      args = JSON.parse argv.tr("'", "\"")
      assert_includes args, "xxh-shell-zsh"

      ssh_argv = stderr.lines.grep(/^ssh arguments:/).first.split(":").second
      ssh_args = JSON.parse ssh_argv.tr("'", "\"")
      assert_includes ssh_args, "Port=#{port}"
      assert_includes ssh_args, "HostName=127.0.0.1"
      assert_match "Connection closed", stderr
    ensure
      Process.kill("TERM", server_pid)
    end
  end
end