class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https:github.comamacneildbmate"
  url "https:github.comamacneildbmatearchiverefstagsv2.9.0.tar.gz"
  sha256 "be8075a0890187f9826a7cfeb7ba48ade6cfce174f82a784935f2bbd835289da"
  license "MIT"
  head "https:github.comamacneildbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dde502fd03d923012b4997c3f4513676e0f59752e68f57c3f6633ac6bb3aaf10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8100da88a2055086d7e6a0c8ac4d8d625b02946a19e2e9041dbbabf60adfa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c32539f834720e03b4f9e9bb58a705547e6a69046e674b5f6e8159b6c323c95"
    sha256 cellar: :any_skip_relocation, sonoma:         "1543bf4799fc557996736c2b196e583b9f6b8811f06a7e252db5a30b5f784428"
    sha256 cellar: :any_skip_relocation, ventura:        "479ec2656eb451324333b4adcda4130d9d116ed72e067516ac40211097d034f6"
    sha256 cellar: :any_skip_relocation, monterey:       "41f1d271dfd7ab3abb54f90cb9c1dc1c2d56793fe98e6f79699d8c4960b2ba90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669fb0e8547b9efcf589a3ea803c06fd27ba22ca1b8b08fdf0d3d8185c077d9d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin"dbmate", "create"
    assert_predicate testpath"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end