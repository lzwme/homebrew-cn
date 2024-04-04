class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https:github.comeclipse-jdtlseclipse.jdt.ls"
  url "https:download.eclipse.orgjdtlsmilestones1.34.0jdt-language-server-1.34.0-202404031240.tar.gz"
  version "1.34.0"
  sha256 "379a796856f2fef5f7eb4b41f2800ab6ee93b078a493327faba2d835142efdd3"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https:download.eclipse.orgjdtlsmilestones"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05f6ee9d359c1e360064be759d9cdfdcf51feba3229b073a21089f668e9240a8"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  def install
    libexec.install %w[
      bin features plugins
      config_mac config_mac_arm config_ss_mac config_ss_mac_arm
      config_linux config_linux_arm config_ss_linux config_ss_linux_arm
    ]
    rewrite_shebang detected_python_shebang, libexec"binjdtls"
    (bin"jdtls").write_env_script libexec"binjdtls", Language::Java.overridable_java_home_env
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3("#{bin}jdtls", "-configuration", "#{testpath}config", "-data",
        "#{testpath}data") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end