class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https:github.comhickory-dnshickory-dns"
  url "https:github.comhickory-dnshickory-dnsarchiverefstagsv0.24.3.tar.gz"
  sha256 "820dc9ccc2db9d87ebe2e7e07aedbae45dfe40a9d5b00388ba691645f3bd2a34"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comhickory-dnshickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "561f39a09766baa59ee07df7c27b13f15fbd1d211beefdb252a9dfbc78e83d57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a65ceb83811f948e9e58e83e0f4f1c49693bdc8a45807bf6a3ed37dcc517ddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a680a774c82806e190820e5da8d76ca34253abbb1ce7a1a133e6e1b8d82442b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5732cf2e944a8ff05834a4e2e53b3d977d06ce3cece855b8e5f39f4ba74c509d"
    sha256 cellar: :any_skip_relocation, ventura:       "0cf9737c1bfa932acb278eecafd7d55db7cd8cf776c32dc7c4e1e5ee9ccef52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1037d4944f860d50d2fe9fc4df0c90ef37abcf10196502e9310de665e1b0fb1e"
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