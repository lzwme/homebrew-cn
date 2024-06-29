class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https:github.comeclipse-jdtlseclipse.jdt.ls"
  url "https:download.eclipse.orgjdtlsmilestones1.37.0jdt-language-server-1.37.0-202406271335.tar.gz"
  version "1.37.0"
  sha256 "d04cd9f4df45ce85ae9cf49530c72a1a324b14eee747af26e3374500e36b5bd0"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https:download.eclipse.orgjdtlsmilestones"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49e7cf48236f9530005592c4954723d77b008e390c93739b679995c2bea4f7ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49e7cf48236f9530005592c4954723d77b008e390c93739b679995c2bea4f7ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49e7cf48236f9530005592c4954723d77b008e390c93739b679995c2bea4f7ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "49e7cf48236f9530005592c4954723d77b008e390c93739b679995c2bea4f7ff"
    sha256 cellar: :any_skip_relocation, ventura:        "49e7cf48236f9530005592c4954723d77b008e390c93739b679995c2bea4f7ff"
    sha256 cellar: :any_skip_relocation, monterey:       "49e7cf48236f9530005592c4954723d77b008e390c93739b679995c2bea4f7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075e2e829eb23d0605691f69297dbd2c14e6e3a834a69e08dc81148651445a89"
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