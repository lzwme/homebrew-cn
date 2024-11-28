class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https:sql-page.com"
  url "https:github.comsqlpageSQLpagearchiverefstagsv0.31.0.tar.gz"
  sha256 "f1547945fdc4a8191a0ddd626f43fa0463f378d2d508877d74cd707d7626e589"
  license "MIT"
  head "https:github.comsqlpageSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e16d96d3dcc50fdf4ed11cbc81aa0668d12bcf1f76853888d669226ea44dc8b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775e65540a76af9ac21e781859408985476877b40142f374aeb0e28625a1eae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a401cdd6fab63bcc35e926e20ef877bf33e86fb9a8af7f19d88141b7f5723aaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dab2e6b9f6c9ef697f4c5d911949a8bdc58a473a74fbf7cdc9001a54736335b"
    sha256 cellar: :any_skip_relocation, ventura:       "c4f3fee67e94049fbd43af76e3650aac42e9b3b36d9f97f56a45ee4f296c2468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf7e4a5f0f16a91c4222e79e88ee530fc22a6a243d8d33732b3d08bae170b810"
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