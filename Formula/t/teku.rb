class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.10.2",
      revision: "3369f5d094a4b50d1311ba2738525806b043e1af"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "527376bc2b1d51e1c7376cbe1fb9c1a4dde60677366ea5499a563f6a020c600b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "527376bc2b1d51e1c7376cbe1fb9c1a4dde60677366ea5499a563f6a020c600b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "527376bc2b1d51e1c7376cbe1fb9c1a4dde60677366ea5499a563f6a020c600b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "770a348ceb5416a5adf25ee66dc4b2863f28ef41c76dcbfff0617d1e45b228d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "770a348ceb5416a5adf25ee66dc4b2863f28ef41c76dcbfff0617d1e45b228d9"
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