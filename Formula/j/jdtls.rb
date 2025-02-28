class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https:github.comeclipse-jdtlseclipse.jdt.ls"
  url "https:www.eclipse.orgdownloadsdownload.php?file=jdtlsmilestones1.45.0jdt-language-server-1.45.0-202502271238.tar.gz"
  version "1.45.0"
  sha256 "c09e79e958beb5ce41fb3b5097aec0455298bc88a14c8e41462b57edb2812797"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https:download.eclipse.orgjdtlsmilestones"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5081b98c6c453f1099f5aed2870e17c14c8db2273aa96a2c533fb10d1b0d9e54"
  end

  depends_on "openjdk"
  depends_on "python@3.13"

  def install
    libexec.install buildpath.glob("*") - buildpath.glob("config*win*")
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

    Open3.popen3(bin"jdtls", "-configuration", testpath"config", "-data", testpath"data") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end