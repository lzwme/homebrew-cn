class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://ghfast.top/https://github.com/atuinsh/atuin/releases/download/v18.13.2/source.tar.gz"
  sha256 "2ad4961618e6ee31652acb4e97b6f05b64b60b1a1317c468e68e5b72d8a70311"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6debc49ec2b2fb6c7ad5770d2951766456fac1c27bd04f9d79809ba42e75104e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b42fb89411551cd8d251a2417467d0be4fdb8e7450a1bd560895e5ce975ac11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "912d51b523edf2219c13d94e245e3952d61da9e8fd47ea71e100b22a4863a20d"
    sha256 cellar: :any_skip_relocation, sonoma:        "33b95c62e3d0b6bf9ab27614257cedd1eb9fe4d780621b85e1044b8d1c6fc454"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "515d9b86600793712c66bd0385f4b0465e56482b163f1e79751e4d37cda89165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46d0940e2d917f0114794b00e8ffdcb76199127175f74bebc0a445de646e75d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin-server")
    pkgetc.install "crates/atuin-server/server.toml"
  end

  service do
    run [opt_bin/"atuin-server", "start"]
    environment_variables ATUIN_CONFIG_DIR: etc/"atuin-server"
    keep_alive true
    log_path var/"log/atuin-server.log"
    error_log_path var/"log/atuin-server.log"
  end

  def caveats
    <<~EOS
      The configuration file is located at:
        #{pkgetc}/server.toml
    EOS
  end

  test do
    assert_match "Atuin sync server", shell_output("#{bin}/atuin-server 2>&1", 2)
  end
end