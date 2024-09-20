class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.1.3.tar.gz"
  sha256 "564222088791c9e308712f910fb9c1c07191d9433ec99178d0c4a36cf8f2ed81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3b91ea2aa4b842122950c3e599a71c99d1ac171cadecfffea0f26580ea53f8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97fca42a61ea8fe4d199f4b09338de8d066e7050b271d969c9b6a6051a80cc26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45b5668513d626a3cc4bdcb3cfdef43595a853e8aa8864c3203b2da71c26e425"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5972cb87d76007df7dcd396b581bcab17afa75a8bd9f52294d8b8dcb4091bcf"
    sha256 cellar: :any_skip_relocation, ventura:       "3484cc4a576531cc7c5c7d454873ebcb2a4be8b1907392c562cb2068fa041eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d3ee1a0d4dbdecf7455f754bbf21bc7b09f816d7eecb6cb145e224945e95c4d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3:test.sqlite"
    system bin"geni", "create"
    assert_predicate testpath"test.sqlite", :exist?, "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}geni --version")
  end
end