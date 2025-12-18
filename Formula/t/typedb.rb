class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://ghfast.top/https://github.com/typedb/typedb/archive/refs/tags/3.7.2.tar.gz"
  sha256 "0eb029ceb84be6d25b84653d7fd34dab708fc44c44965c290398a71f6f2f1926"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d4b71f2f1d936b4478b1350f651c973cbf1dcf7d2f5be03621dc96521ef79cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb6f59c177a75e0ada51fa413a0b429ce79b4d4c6eaf1fd93ff1787521c266c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6ebba0c9c893074f58ceb8e3fd509e1262d3a66aa255546e51c73d7c05fbf14"
    sha256 cellar: :any_skip_relocation, sonoma:        "19d7f606482ae54bd649e7552c0bfd9fe973a2701c5554c10dc4b93714c88f68"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

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