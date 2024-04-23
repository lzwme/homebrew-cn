class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.20.3.tar.gz"
  sha256 "cc19f160ea10d14c3ff6e9203d7b3138bca95adefc0307e8d252be5b935d8f07"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ce4197a013d9b81b460d8d6b29738d5c9dd9fda3b03a5586b9e25a746f13d96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6edd2347c80ed11883aa3d561b6268518ff53b0233bc7a0d25c9549cfb75978f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8ac5d565c59cbcb59535518ace55d30da0ce27a791f2f1ff14646c8e7d8930b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5dddbc8a0a8efc4df7838b26539a2a5c83156cabd30be3c6bbe830d47a2f5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9069a11425afd4529248cf2be8337a6e8a7bc1afc0750fcbeb43a808fad237"
    sha256 cellar: :any_skip_relocation, monterey:       "8ffcb4283bcc364cf7a75844f3f37ee03d46717a3fcf616133c95fc744d7374b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47cdcb4a0ae229ef308c9615fb5f645d324374e099b30f48e28312bd414e7e32"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http:localhost:#{port}")
    Process.kill(9, pid)
  end
end