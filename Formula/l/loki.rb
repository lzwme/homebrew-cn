class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://ghfast.top/https://github.com/grafana/loki/archive/refs/tags/v3.7.7.tar.gz"
  sha256 "e2e8863c15ad97a4649a6f0795d549a8977e44f4413e2b001e6eb0c12c22eb9c"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b4f9c924c68e847164ca915d670b8b8a895c6808fa1a5b387a87ce8ca4fffad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9adc62409322e96671b7605946c59c67df0894db1b7fb218563ed0a6c15f8e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df7527e495f6a80a298895c8e4fb3d56d8e2246d71564528b12cea31d8f4ccd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cb779bc4c6c2b0200e9ffb35629c57dc0d505f35af46ba4fb9727aaa9404ed4"
    sha256 cellar: :any,                 x86_64_linux:  "35e1b1374fa7b9490ff3335c35b6b80bcec3abcd83fcc1408d5f506f1f173c09"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    spawn bin/"loki", "-config.file=loki-local-config.yaml"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end