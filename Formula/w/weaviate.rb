class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.7.tar.gz"
  sha256 "301734f751cbc85664fd9500a24804916d2b7b46d40f1b9d20f8f953ea94abc9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7aa1b7f0505ea6b55cb144db255f5b04f85f9a7a162598ecc385e15509380ca4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7aa1b7f0505ea6b55cb144db255f5b04f85f9a7a162598ecc385e15509380ca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7aa1b7f0505ea6b55cb144db255f5b04f85f9a7a162598ecc385e15509380ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7f0a64489d642855afac8ad51595342e573e4c61aaec4dfaae21e4514959b3c"
    sha256 cellar: :any,                 x86_64_linux:      "a6dd529a55ae65f437d83affb23d23e3a38c42beda077bfd159599d60a22bf3f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end