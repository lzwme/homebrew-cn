class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://ghproxy.com/https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "1bb9b5da7ee6e481861431900d7775ffcd148f78f16810b1c657a6351751c4ba"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07a67efd78755fbf6c46ec2baf3ae01d786f71569c3dfd6e7b8f6167458e693c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b2d89c6d0665a29c444a4fbd3446bfe635264e88001666b2600da5389bb840e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9a2d8662aeb8432a7ae46e40ac0b1d476d388c3b5bfc5e0a243f57a8a4c2853"
    sha256 cellar: :any_skip_relocation, sonoma:         "33d7e9b9462ce5c71aa784998905c43e89b1e5f1d49cc729c6578c9c67753f60"
    sha256 cellar: :any_skip_relocation, ventura:        "09305db7e078f2ff79c1b8c9ad56d36374662f8b68acfac612cc54a2a2eac73c"
    sha256 cellar: :any_skip_relocation, monterey:       "34bce546085eb7e2ffc3b5e4985b207fc17c294aad0144f6081a8ed4f744482b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90bf947e6dc246064c90fed231d76db110d0b6303bd7e4b4a26159f9252e92a3"
  end

  depends_on "rust" => :build

  def install
    cd "meilisearch" do
      system "cargo", "install", *std_cargo_args
    end
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    fork { exec bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}" }
    sleep_count = Hardware::CPU.arm? ? 3 : 10
    sleep sleep_count
    output = shell_output("curl -s 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end