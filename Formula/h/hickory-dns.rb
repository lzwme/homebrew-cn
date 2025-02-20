class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https:github.comhickory-dnshickory-dns"
  url "https:github.comhickory-dnshickory-dnsarchiverefstagsv0.24.4.tar.gz"
  sha256 "c7dbbee6d32640a30193b708d48003de92df2313d9ead8096b265065a17745b6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comhickory-dnshickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e275881170e607c5bd0afea1732395ac71ee40c80c7fe56f0214bc2f44453dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e074a448cf6133446c5ad7ab3fe5d28daecbc9a075b6b9a2a6917e4a1b1d467"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc7889e91482c87fd965136c1d81132f804db4abd603b78f01b500f21ce5446e"
    sha256 cellar: :any_skip_relocation, sonoma:        "588911e3addb0738c7c8b681c4d890f13d5a953bce15966e32292869dc565708"
    sha256 cellar: :any_skip_relocation, ventura:       "463c857879d5b33266d4a753dc67f601241838480bea44a695f4b8f9cb847a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "561baa561f718d9b91ac5b6e254cb6f24b1700d30e4fba737e6213b627e6ed56"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
    pkgshare.install "teststest-data"
  end

  test do
    test_port = free_port
    cp_r pkgshare"test-data", testpath
    test_config_path = testpath"test-datatest_configs"
    example_config = test_config_path"example.toml"

    pid = fork do
      exec bin"hickory-dns", "-c", example_config, "-z", test_config_path, "-p", test_port.to_s
    end
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{test_port} www.example.com")
    expected = "www.example.com.	86400	IN	A	127.0.0.1"
    assert_match expected, output

    assert_match "Hickory DNS named server #{version}", shell_output("#{bin}hickory-dns --version")
  ensure
    Process.kill "SIGTERM", pid
    Process.wait pid
  end
end