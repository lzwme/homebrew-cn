class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https:github.comemilprivergeni"
  url "https:github.comemilprivergeniarchiverefstagsv1.0.8.tar.gz"
  sha256 "982380e8fce1dec49f29ed1517acc954c7cfbfc95ab1777dbe8a1aa724b441c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e0a88b8fe473af864e2195b907a42c964242ad2c055fb849dabbb04772ae892"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67453ad0beeb87cdaeee8a4b45053faab286277b5e0b442ec4844609de48da7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41323d356502d6fa86164f8616d5bf8dda8f72dfd58952315812176a5bff6747"
    sha256 cellar: :any_skip_relocation, sonoma:         "08c8952e211028abbc8e9269d2c9306baf0029e2a8edc29ec742435fe6c96d25"
    sha256 cellar: :any_skip_relocation, ventura:        "a826ccf6cb5c6c9ed01754e1c8d3ebe68d1351bd8470db59f09dc51eede22ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "8a7556b20f2d229081bb249aab5d6c709f2b86cd9b06b626a83b3ccd274820cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb46bdf4e8bd839bbee12c6b9ae48c18bf67d03092fa33f5251357dc6299961"
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