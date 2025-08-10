class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://ghfast.top/https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "894cec90bc749f342e55e05b256cdba9986add0d2db6d144bfdffdb5b798b675"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df2caa6afbe816a9e09e70a9135a59509d45827ad3dc65b17e1f5f5b87ec0e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a975c372d2c798ebba704d4ce80392d9eb9c6333794dea41169bdc8158894cd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af76c492222d2be1120e51a8eb42b21eaf5f78d3c9e052295e20b407bc8c4a3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "69829705bd309433951e4edb7ff458932d886b812fcc0713064e8dc4e8ea5698"
    sha256 cellar: :any_skip_relocation, ventura:       "bab95c3e00bad069e8b34187211cd6ee4535013e9b9e616af663f32d777e27b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d5bfc10349ab217e90f8150201ac4c1be20b9f4f6984a03de4e60f128c2ad80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35fe8c179b244ba4b7b93f1bd2a57e2526ac0709a979231eab76754beecf1a16"
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