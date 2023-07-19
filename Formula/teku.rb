class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.6.2",
      revision: "aefb5e29ed874aab51329be99da7418f78db4928"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab40ff479aad3c34667d20a15cebfa1b7364620cabde5f61fb119e0addf5561b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab40ff479aad3c34667d20a15cebfa1b7364620cabde5f61fb119e0addf5561b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab40ff479aad3c34667d20a15cebfa1b7364620cabde5f61fb119e0addf5561b"
    sha256 cellar: :any_skip_relocation, ventura:        "8fb66829220aebdd8e54f0d18b2a553b82648ef53501bae20f0a11379baa9b25"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb66829220aebdd8e54f0d18b2a553b82648ef53501bae20f0a11379baa9b25"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fb66829220aebdd8e54f0d18b2a553b82648ef53501bae20f0a11379baa9b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c3dcfc965168c78d392f79aaa42c7cc33e588b08310aaf28de46a6e8a6b12c"
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
    fork do
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false", "--ee-endpoint=http://127.0.0.1"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end