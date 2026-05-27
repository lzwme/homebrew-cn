class Rabbitmqadmin < Formula
  desc "Command-line tool for RabbitMQ that uses the HTTP API"
  homepage "https://www.rabbitmq.com/docs/management-cli"
  url "https://ghfast.top/https://github.com/rabbitmq/rabbitmqadmin-ng/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "0a833e65e0c21b162fef7a1e2955dda885b47c3d6c842b7e170c7ccee1004a9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99dccf3b7bc08a84336c6cbc716a3c21a0cb745514ec307936317e1ed35679ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f2d80798080a32f1514cb9d93fbc5b55f6ff899315025c8108eac4d3dee961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb80378905d0555239b085fb23917c2dcdaafaaeff9d79ad92026e0e738b1670"
    sha256 cellar: :any_skip_relocation, sonoma:        "26dfec913e22e26453c8729dace645976cdcda57bc2e98540352857f08064519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87560fd2d75dc3b008c55e378010c97c747c8a025a909cc31de2f493af08bcb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf131083d2978ff9ebe3bd4302def792f03772007492055d530206fafae76f6"
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