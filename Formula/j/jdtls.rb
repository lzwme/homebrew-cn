class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https:github.comeclipse-jdtlseclipse.jdt.ls"
  url "https:www.eclipse.orgdownloadsdownload.php?file=jdtlsmilestones1.41.0jdt-language-server-1.41.0-202410311350.tar.gz"
  version "1.41.0"
  sha256 "adab7e8991d5bc379b5f4381e932353e4bc5818b2c3d80dcd78d12a3c2a897f5"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https:download.eclipse.orgjdtlsmilestones"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c6cb680b6d23971e3a19727b89f1ef077f47acc8e0ff62074420f1d7e6fd4ea"
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