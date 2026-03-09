class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "63e08e4489415e6880b4c69483749984a579a72b751f615766ca74112166d5b4"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a785043107f6a5ea567aa1301d520cf62e37970f3a49998eec7c9865d573575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54709bf6209763a065db1d29362168c1753ae5ff77cc15dd6c70082cfcaf9d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70bb8cf5633306d4fea22fcbf925d9cdad2b05ecc9858726072d7a2f3764df7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "316aa47699c39e3391b67ff550d511efea03d5c30310f677dc10516cad870722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a8a6c8f6b0eba675c60c6e31f41e1526a2ca33fb899fae304ac2d819bbfc67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4915455560c8f8bbafc24986c5a8059dacb95046e78a76492a4ebbb84572a137"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end