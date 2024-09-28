class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https:github.comeclipse-jdtlseclipse.jdt.ls"
  url "https:www.eclipse.orgdownloadsdownload.php?file=jdtlsmilestones1.40.0jdt-language-server-1.40.0-202409261450.tar.gz"
  version "1.40.0"
  sha256 "7416fc62befa450e32f06ec2b503f2eec5f22f0b1cc12f7b8ee5112bf671cf11"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https:download.eclipse.orgjdtlsmilestones"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ede1e70ee9db9d7d2d584b89e1e8a50c1c24e4d1b0bb7817eea50a496b5d98a"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

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