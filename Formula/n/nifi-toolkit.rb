class NifiToolkit < Formula
  desc "Command-line utilities to setup and support NiFi"
  homepage "https://nifi.apache.org"
  url "https://dlcdn.apache.org/nifi/2.7.1/nifi-toolkit-2.7.1-bin.zip"
  sha256 "d1bc36163f8d284d2526819fc35a1348ee02d6e6593e0505e255d64026199332"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e37716d04ae6a28c2d9f3b72b49cfc6cf37d9fb08e62b4bca7eb7674011fc1dd"
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