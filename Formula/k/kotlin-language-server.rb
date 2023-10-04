class KotlinLanguageServer < Formula
  desc "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol"
  homepage "https://github.com/fwcd/kotlin-language-server"
  url "https://ghproxy.com/https://github.com/fwcd/kotlin-language-server/archive/refs/tags/1.3.6.tar.gz"
  sha256 "1e8151a4495fed21a0e4e925203b3f8c67f2c2cf5f4d6006b174822ec48216b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e4e72a406d5a8c15cea8f0bde7761f737068a5ec95db04e079bbce02c7a520c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3353fee430b9058b366efd38386e9e9d6b64d17cfa99a3f49afee455ef153c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "526c097297b85866afb573485d241d99dd9da9aef376bbb74446d72c8d98056d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0acf70d02b32fd0e59d33f128a23833176f320425059577f0d931db0bd85c757"
    sha256 cellar: :any_skip_relocation, ventura:        "5b5bc3a2d946a102228ed6c09c0fb0f702e02da6d5eb22df6da367a5d9741422"
    sha256 cellar: :any_skip_relocation, monterey:       "0559a9ea167687b28d894efc6c97d6e4f4cf0df696a15ea96d84971ac3fda46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f8c77821236f9520d51e039e17c575fc2568a8f34994a6a3063c10be18680df"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@17"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    #  Remove Windows files
    rm "gradlew.bat"

    system "gradle", ":server:installDist", "-PjavaVersion=17"

    libexec.install Dir["server/build/install/server/*"]

    (bin/"kotlin-language-server").write_env_script libexec/"bin/kotlin-language-server",
      Language::Java.overridable_java_home_env("17")
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/kotlin-language-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
  end
end