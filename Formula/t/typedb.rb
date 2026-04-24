class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://typedb.com/"
  url "https://ghfast.top/https://github.com/typedb/typedb/archive/refs/tags/3.10.1.tar.gz"
  sha256 "6fc8d4d6525f15afda3f3d8a2814d38e8d45b544c09cda32bb7018ce48610a43"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1021dcd639a40316b75c82a6471263f82ab392dda24b725da5018e04456dc139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87853ff6c19f5b7822666943234e1a8c786af6dbbf9a5ef7b3af27dc360b250e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f678291f8f1f99df3916a996999a9027d86145b2ba878ac4b896161baf595e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6006dbf79149d64c07fbb3bac75f9d9e4340809e642ee83f343c143611385e52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d350d9c8fe573d7213df0f5fc4c1e473261182920dedfc3f9e2970ebb2fdec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c24f28b696b3222db8103fad9d5d5fde3052d5e231749609450785bc9859c464"
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