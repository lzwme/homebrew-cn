class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https:github.comshssoichirooxipng"
  url "https:github.comshssoichirooxipngarchiverefstagsv9.1.4.tar.gz"
  sha256 "90c5e32c556c49e8fb2170f281586e87f7619fd574b4ccf1bc76e2f6819bba77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "668b8d167ddc952d0ad8b146695abf06cd5cfc75c3708d40091a6289351f43ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8710b20b4af22087fa5f06f190e155d0969e6fef2b3815f35b307c68756395b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d06dcc039c3bf834b3113edaf709b8078be595da4aaacc67506e8233db7279e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d39e08ae92fb6fccf442b2ae25df9d10bea2ab455f81165a3b2b554b097b2d"
    sha256 cellar: :any_skip_relocation, ventura:       "0982090f6d9c96ce7cff3fe657a821be958d466a9fa3e22887f4cb2111523419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c5729f0c726dfe3a4b0cff7dbf3e149c07e392d260db707c99a80ed0b0e4264"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "run",
           "--manifest-path", "xtaskCargo.toml",
           "--jobs", ENV.make_jobs.to_s,
           "--locked", "--", "mangen"

    man1.install "targetxtaskmangenmanpagesoxipng.1"
  end

  test do
    system bin"oxipng", "--pretend", test_fixtures("test.png")
  end
end