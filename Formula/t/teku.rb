class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.12.0",
      revision: "24ba349c13952e333eabbc89dbcfe4241e4fce55"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4fecf7fe327364d5a2c2398da6960c8c655fb06d4f7086abd2e6f4a90dc6f68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4fecf7fe327364d5a2c2398da6960c8c655fb06d4f7086abd2e6f4a90dc6f68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4fecf7fe327364d5a2c2398da6960c8c655fb06d4f7086abd2e6f4a90dc6f68"
    sha256 cellar: :any_skip_relocation, sonoma:         "190bbbf504736ce37cf3382a0f5ad9e1d6f62626e5eaf49c4fc45ae9c48e45b6"
    sha256 cellar: :any_skip_relocation, ventura:        "190bbbf504736ce37cf3382a0f5ad9e1d6f62626e5eaf49c4fc45ae9c48e45b6"
    sha256 cellar: :any_skip_relocation, monterey:       "190bbbf504736ce37cf3382a0f5ad9e1d6f62626e5eaf49c4fc45ae9c48e45b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4fecf7fe327364d5a2c2398da6960c8c655fb06d4f7086abd2e6f4a90dc6f68"
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