class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "25.7.1",
      revision: "6faba5e5406548739c3edf158987cc7598b49f70"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe0564c021df4f6780599e1c00a377449ee97be3b26cea5a90a3878bf650ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe0564c021df4f6780599e1c00a377449ee97be3b26cea5a90a3878bf650ea5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fe0564c021df4f6780599e1c00a377449ee97be3b26cea5a90a3878bf650ea5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e10e1536205a337350342b1f44407583e508fef2ce9a68a41f9974ba9ca74b3"
    sha256 cellar: :any_skip_relocation, ventura:       "1e10e1536205a337350342b1f44407583e508fef2ce9a68a41f9974ba9ca74b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe0564c021df4f6780599e1c00a377449ee97be3b26cea5a90a3878bf650ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe0564c021df4f6780599e1c00a377449ee97be3b26cea5a90a3878bf650ea5"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "installDist"

    libexec.install Dir["build/install/teku/*"]

    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    test_args = %W[
      --ee-endpoint=http://127.0.0.1
      --ignore-weak-subjectivity-period-enabled
      --rest-api-enabled
      --rest-api-port=#{rest_port}
      --p2p-enabled=false

    ]
    fork do
      exec bin/"teku", *test_args
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end