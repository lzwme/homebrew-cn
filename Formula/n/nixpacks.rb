class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://ghproxy.com/https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "a8aaa59a1f0d864b958cc308c2c8000627c9d0985ec5e4d166afc9b6e9479234"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc1e9fc469ccced1c135f7c2d9a62207712d2a970ad539b64f8584e413351afd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e981c494932bc0640b7e95506f839efd67c3521b846eedf9e895a75aff3b5c1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38cf8de8452db9572bd0c4f723bc653f837627e5ba568ceb55a46ceb9c7e5bb7"
    sha256 cellar: :any_skip_relocation, ventura:        "17224a95c3fee7743e52d946424a8e7262d86c74d5cd2ad31729b21ca6a42521"
    sha256 cellar: :any_skip_relocation, monterey:       "ed89beb6c397ece036130af3e1cf5e78c02086236954c2c80477279b7bd59920"
    sha256 cellar: :any_skip_relocation, big_sur:        "697e3447ed9f648a576b67d61923da6fe0daa091281de328b611b414317a2b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20170edfae14d77bb4c77538d8d212d875fc3b31a88b3438d24b995991fad88"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end