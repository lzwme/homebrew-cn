class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.6.0",
      revision: "44baab9e39f912f0d6c47423e1fdfb1b941ab9de"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da22ddbb63245dee6748ad3494e0af664656f5a7d69dca304a12b062efb83d46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da22ddbb63245dee6748ad3494e0af664656f5a7d69dca304a12b062efb83d46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da22ddbb63245dee6748ad3494e0af664656f5a7d69dca304a12b062efb83d46"
    sha256 cellar: :any_skip_relocation, sonoma:        "da22ddbb63245dee6748ad3494e0af664656f5a7d69dca304a12b062efb83d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f80c198c83b42196637b9984f898dd1e7fd8c41fb55bb674e080ed43e3498958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f80c198c83b42196637b9984f898dd1e7fd8c41fb55bb674e080ed43e3498958"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")

    system "gradle", "installDist", "--no-daemon"
    libexec.install Dir["build/install/teku/*"]
    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env("25")
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    test_args = %W[
      --network=minimal
      --Xinterop-enabled
      --Xinterop-number-of-validators=8
      --rest-api-enabled
      --rest-api-port=#{rest_port}
      --p2p-enabled=false
      --data-path=#{testpath}
    ]
    spawn bin/"teku", *test_args
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end