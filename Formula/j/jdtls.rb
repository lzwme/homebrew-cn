class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse-jdtls/eclipse.jdt.ls"
  url "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.52.0/jdt-language-server-1.52.0-202510301627.tar.gz"
  version "1.52.0"
  sha256 "57e6b453665354b42a898827d2ab938a3ec6b41c1272c109983c3b7a60ec4785"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https://download.eclipse.org/jdtls/milestones/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07641d5fd03dc7443d358b8311f91966042c4bbbcd0350f46bec3199798cbb44"
  end

  depends_on "openjdk"
  depends_on "python@3.14"

  def install
    libexec.install buildpath.glob("*") - buildpath.glob("config*win*")
    rewrite_shebang detected_python_shebang, libexec/"bin/jdtls"
    (bin/"jdtls").write_env_script libexec/"bin/jdtls", Language::Java.overridable_java_home_env
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

    Open3.popen3(bin/"jdtls", "-configuration", testpath/"config", "-data", testpath/"data") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end