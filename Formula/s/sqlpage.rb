class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "d349fba5b6d26b7a8b1ad6c0f255f429f8134c0325c1b3b82dc60262ed03b705"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7d8483a09b2bac764775689933bd1d56b52ee6df5f53bb4de0993f35753ab50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9655d24e41d704f68db751cb126b48a564f01d96af6ab9cbc15a5c15e16c81c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5580088080162ee57c34a0d1e801d4fb913e2bd515caa56e818c918700df93f"
    sha256 cellar: :any_skip_relocation, sonoma:         "380f7afa00bbb35e3055f88b66a8fa5676748e8f3948c011efa90f3697f243e7"
    sha256 cellar: :any_skip_relocation, ventura:        "c470f301045c8776543b72385e726eed3b2ee7160259446773a7bb7fe9c5d6ec"
    sha256 cellar: :any_skip_relocation, monterey:       "756e9bf13a23348ce37aed2e2e0f2a35437eb6768e506d525eda1bafa8e214b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac360e0ec6ae7cc989845b888628f423051b399d8bd5e55e73abed44c00081b"
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
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end