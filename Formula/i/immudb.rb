class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://immudb.io/"
  url "https://ghfast.top/https://github.com/codenotary/immudb/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "9d4cebe7fa2885580e0ec4bdbf3c5ef45dd543c1d473a984f64d56c7267dac5e"
  license "Apache-2.0"
  head "https://github.com/codenotary/immudb.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbecf59a643862ee00b3b2099173c90e2b6d5613c78c789703da586e425b22d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae8084c5aebb453c8a67296fca15146e7ee1ef1b2f5fc0a2c45e56b143c0f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fec8f57d6c166e0b5ee82c6f2aeaa596c233227db335b5e7c609ff5209cad29"
    sha256 cellar: :any_skip_relocation, sonoma:        "eed34ea7f0cba6e9b99f689917a0fbb5186d55a31853cd8b0762de233aec9834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec1a1b61c0cd73ef9fa5143010502594bcfbd3afdbf6bc4e5d1f41aab5c76af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dc3e9a38703c07ed987f3c9e95735cddc3b44482a7d3b953dc25f2492bfe403"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(bin/binary, "completion")
    end
  end

  def post_install
    (var/"immudb").mkpath
  end

  service do
    run opt_bin/"immudb"
    keep_alive true
    error_log_path var/"log/immudb.log"
    log_path var/"log/immudb.log"
    working_dir var/"immudb"
  end

  test do
    port = free_port

    fork do
      exec bin/"immudb", "--port=#{port}"
    end
    sleep 3

    assert_match "immuclient", shell_output("#{bin}/immuclient version")
    assert_match "immuadmin", shell_output("#{bin}/immuadmin version")
  end
end