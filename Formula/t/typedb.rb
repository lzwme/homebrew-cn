class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://ghfast.top/https://github.com/typedb/typedb/archive/refs/tags/3.11.1.tar.gz"
  sha256 "fcca8c0522505f7f5745469ff877270a9c8eda91ec70ce1635cef09a29f653d6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a3082a7d2bbfa24df1b14121ea25bb2023ed4d66cefdea2e37a45b746de032f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37ff0ff7d6ec9b218f277b9c64e909318239656fbecfd80eac990bba5534935d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ace79f2d142688720ab8285a3390d6689ee292bb1d8f54dcaa86a28e7f9b70ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba9f8df1a37c84767847c7970105d6c96e275604a5e049ce6ed3a1c55f7aad84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be1f95e95f9d2fca32d5c4e89b05c449f4930e1419ecd3171ddc93d7e9db774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d87cd1b03096ac06bbf9d02a3e78f174f7b655604243a3811ddccf2203e9b1"
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
    assert_match "Serving:\n  gRPC:  0.0.0.0:#{server_port}", output
    assert_match "TLS: disabled", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end