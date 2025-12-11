class NifiToolkit < Formula
  desc "Command-line utilities to setup and support NiFi"
  homepage "https://nifi.apache.org"
  url "https://dlcdn.apache.org/nifi/2.7.0/nifi-toolkit-2.7.0-bin.zip"
  sha256 "e893e8ef84a5c0fcc9b4c39e16b95a6ebe0ea08ea3bcca137f54da6fef9d8568"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed74eee890f8ab6ff09f82750c22ff51ba3a07bf1b41aaf23119c1dc3dd915f3"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi-cli").write_env_script(
      libexec/"bin/cli.sh",
      Language::Java.overridable_java_home_env("21").merge(NIFI_TOOLKIT_HOME: libexec),
    )
  end

  test do
    assert_match "commands:", shell_output("#{bin}/nifi-cli help")
    assert_match "Missing required option 'baseUrl'", shell_output("#{bin}/nifi-cli nifi get-node 2>&1", 255)
    session_keys = shell_output("#{bin}/nifi-cli session keys")
    assert_match "nifi.props", session_keys
    assert_match "nifi.reg.props", session_keys
  end
end