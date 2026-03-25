class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://ghfast.top/https://github.com/typedb/typedb/archive/refs/tags/3.8.2.tar.gz"
  sha256 "0c278578cf93d1dffe5909922ceba398b23a374126988d09bd0d9fd867450a20"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eea0c2ea160f8b4ad1d1e2f094dde5334a59e189f320a626437ffca2d5cf3b75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3451dc69c20e877030bc8182668bff05a05c626f52f1f36663cb6dfc468c8b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05bf45758518825aa0c8d50358a5edcc7e0d46e750f49f1271737caab8b424a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a9d2f3985b5f3bac5ce690b1a761c0a8737777f56b328a1df3ec355cf2e5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38bf185671cfbde4165ab672996fb9e8a81167cb4cd9a4f6b7032e3a59d7832f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601895dc0125115e67c11cd5a32f1014da2db143f97172fc9b9660ee26a36e0f"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "typedb_server_bin" => "typedb"

    inreplace "server/config.yml" do |s|
      s.gsub!(/data-directory: .+$/, "data-directory: \"#{var}/typedb\"")
      s.gsub!(/directory: .+$/, "directory: \"#{var}/log/typedb\"")
    end
    (etc/"typedb").install "server/config.yml"
  end

  service do
    run [opt_bin/"typedb", "--config", etc/"typedb/config.yml"]
    keep_alive true
    working_dir var/"typedb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/typedb --version")

    server_port = free_port
    log_path = testpath/"typedb.log"

    (testpath/"config.yml").write <<~YAML
      server:
        address: 0.0.0.0:#{server_port}
        http:
            enabled: false
            address: 0.0.0.0:#{free_port}
        authentication:
            token-expiration-seconds: 5000
        encryption:
            enabled: false

      storage:
          data-directory: "#{testpath}/data"

      logging:
          directory: "#{testpath}/log"
    YAML

    pid = spawn bin/"typedb", "--config", testpath/"config.yml", [:out, :err] => log_path.to_s
    sleep 5

    output = log_path.read
    assert_match "Running TypeDB", output
    assert_match "Serving gRPC on 0.0.0.0:#{server_port} without TLS.", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end