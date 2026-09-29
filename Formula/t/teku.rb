class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.9.1",
      revision: "f863a700aaa976fb0cb080ecddec4637daed72f0"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ecd0a797de23094a9e3c83682f3b10aa2dac10612b84f124ace287399b23b9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ecd0a797de23094a9e3c83682f3b10aa2dac10612b84f124ace287399b23b9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ecd0a797de23094a9e3c83682f3b10aa2dac10612b84f124ace287399b23b9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4bbaff2e396d60a04e2cfef3c24cbc97494a6b090bf469e0f397ce91f7b3f345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4bbaff2e396d60a04e2cfef3c24cbc97494a6b090bf469e0f397ce91f7b3f345"
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