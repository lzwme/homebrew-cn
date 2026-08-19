class Rabbitmqadmin < Formula
  desc "Command-line tool for RabbitMQ that uses the HTTP API"
  homepage "https://www.rabbitmq.com/docs/management-cli"
  url "https://ghfast.top/https://github.com/rabbitmq/rabbitmqadmin-ng/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "0eea0ef610383d4270a1aed8f2ca39a218d212406fae5ec2df9bf08bb81a00de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ee39240210dc58e43484b3be9e713f1ff6dceb0c20085dcd3c56c881cdb71d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "887445fb5ad5c4a515d6ffc44dd74d2bd256159078ddf915f3db512394f11444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f12d5eaabbcc61afe4f9001ac57f4bd4a97a26a93da98f687f31665ea59304"
    sha256 cellar: :any_skip_relocation, sonoma:        "0790858af041b453d3248e2fbcf22c064b0425e9f610193eaa2651a44eaf6cfa"
    sha256 cellar: :any,                 arm64_linux:   "92e24729c739b2c3adf70b098b3393b688af31346d15d4708ac3d4b13a2871ea"
    sha256 cellar: :any,                 x86_64_linux:  "9414c66d052d8916b91592ca3e54c2de3a9043b5329d4752343bafe525acfed4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rabbitmqadmin", "shell", "completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rabbitmqadmin --help")
    assert_match "Configuration file '~/.rabbitmqadmin.conf' does not exist",
                 shell_output("#{bin}/rabbitmqadmin config_file show 2>&1", 65)
    assert_match "error sending request for url (http://localhost:15672/api/channels)",
                 shell_output("#{bin}/rabbitmqadmin list channels 2>&1", 65)
  end
end