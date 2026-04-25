class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://ghfast.top/https://github.com/typedb/typedb/archive/refs/tags/3.10.2.tar.gz"
  sha256 "57fd96117b64ab39aa8728bdb56c991735f34880e98a2c333b206adde90d806c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a4eebe368571cb36c999838ac3cc3656df4919f485a5206911ef0ad4e8e5d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc19626703eb3bbc9d3cb8c6de87210b41ea1e23920b5bef4ff116ffc168f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c371651d08b52f55ed9a25611a0db810098bc1656401a82e357cf23469e98d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd8e0d1624906eab65bfb8d25001d665b10b99e6db782d372fc8960acb4f0676"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "895d3431309a65b0a674acd0fe80dd95e556c819a2cb4df644a240758b6a111c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b95f62d9fe9b0de25d653f09b108b7bfdc6bedd0dae6b2612af12d4c8a3b30a"
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