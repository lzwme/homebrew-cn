class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https:github.comdolthubdoltgresql"
  url "https:github.comdolthubdoltgresqlarchiverefstagsv0.3.1.tar.gz"
  sha256 "6d2458306755489f84ef6ac78bdf58f090511d2d3b099c3ff429a04daf4be024"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "642a7b60f23e9db380c175e4f372d37c7a6b14ed98e09487b31289b6ac17e66f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1290530e02f78ff86eeb501717c0380328847b45ea36accb5a069decfe2c0734"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17588e3c6fb1248a1f6e9b8a2d1ed51c8650078938b37daeaeb671365cf8e549"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e2ea85e907ef8621f6db7aac80afb41497e9945f6a433776c8cb3f6458abd49"
    sha256 cellar: :any_skip_relocation, ventura:        "463e188f2d323a8da3ba3b4c53441a3013207fe2513df65dd5f2ad272d231c72"
    sha256 cellar: :any_skip_relocation, monterey:       "6e4e1b87be34f167fb67b34fbb61e9a86521e6dbfdbf0e45451c6c2b13b5d84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1d5a3c5b62d6e80bda010dc9aa870772ee8d236a0b98ed56288d3c8f9ffefe"
  end

  depends_on "go" => :build
  depends_on "postgresql@16" => :test

  def install
    system ".postgresparserbuild.sh"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    fork do
      exec bin"doltgres"
    end
    sleep 5
    psql = "#{Formula["postgresql@16"].opt_bin}psql -h 127.0.0.1 -U doltgres -c 'SELECT DATABASE()'"
    assert_match "doltgres", shell_output(psql)
  end
end