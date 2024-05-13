class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https:lune-org.github.iodocs"
  url "https:github.comlune-orglunearchiverefstagsv0.8.4.tar.gz"
  sha256 "ff254da9ed4f3f2cf171f69015ce833e3954a8fa2e357aa208718e2e53ed5a01"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8949c764721a0bf40b1776e7eae8c602072219b7a751189defafefe4946b736b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37dd8caaeead1b25fe127b50e10ba6c05dc0058ae6289121da794919d4a07546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1caa82efddfe56d2317690f62c84a06ba86fd82be0a8ab1674393fb029d0b55"
    sha256 cellar: :any_skip_relocation, sonoma:         "eda471d35b8474f79538a9532ea54e013ecc1099158c2a881edfb5c9249293bc"
    sha256 cellar: :any_skip_relocation, ventura:        "d3b5cb8e2f5ead4b3ece429ea70bbbf0cae68d76afb6be17d0816f8626f91cca"
    sha256 cellar: :any_skip_relocation, monterey:       "aa20bb57f1b6a5eed583ca3fed7adc5fef4c8e8e5ab276efd1d7a4ed3d324ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5feeced3cca6d54736debde01907b953efbcda2c7c412da324ed8c42e58e2e73"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crateslune")
  end

  test do
    (testpath"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}lune run test.lua").chomp
  end
end