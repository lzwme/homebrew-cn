class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.10.0",
      revision: "a46f9e1e3679e4c2707d27447628d07a6c67b600"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "55d635f1e1c721f6aae6819849e8df2fe395ad33d1d550bb0e5c73c59a8704f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55d635f1e1c721f6aae6819849e8df2fe395ad33d1d550bb0e5c73c59a8704f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55d635f1e1c721f6aae6819849e8df2fe395ad33d1d550bb0e5c73c59a8704f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7fc4f0369123d0529b18ffb21dbd6b5557e80c91ac36a5dd50a03f151c332264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7fc4f0369123d0529b18ffb21dbd6b5557e80c91ac36a5dd50a03f151c332264"
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