class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https:github.comamacneildbmate"
  url "https:github.comamacneildbmatearchiverefstagsv2.26.0.tar.gz"
  sha256 "2fb78ed466505f20a4b060b8e103c6010bf788a4445b19ec1f0e5589739fc659"
  license "MIT"
  head "https:github.comamacneildbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5488fc2329580356f56cf419b959d36fae658d8772788d4a9955d847966ea5fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a63090865c86605f0bea9942f38ead2bf1c50e45e75031e696b3e123c60fae15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f84e43ce1411361824235b733e1ddb6a55ea76708052d291c30193cb7532d91f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0f7eb6df928ead6903c433d9c67745804cb3929bff41268691e25c7919b3095"
    sha256 cellar: :any_skip_relocation, ventura:       "3f840fd772c6ec5e2a841b3e66a3305349d2dbaaed9d2210fa90156068142cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68c1c09e79ec70027a3f20586d8326ee7c64c029b452a7892b0761c21dbad44e"
  end

  depends_on "go" => :build

  def install
    tags = %w[
      sqlite_omit_load_extension sqlite_json
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
  end

  test do
    (testpath".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin"dbmate", "create"
    assert_path_exists testpath"test.sqlite3", "failed to create test.sqlite3"
  end
end