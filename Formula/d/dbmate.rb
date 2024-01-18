class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https:github.comamacneildbmate"
  url "https:github.comamacneildbmatearchiverefstagsv2.11.0.tar.gz"
  sha256 "279e1a91d2775b0200177646a838a90dfec5f176d83f7d61e26ec6f3f94dc64e"
  license "MIT"
  head "https:github.comamacneildbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ff3bc7dddba9a73d2a75cc15b490a04afbe5c20599a44b1a84e9ab701930ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1103d92c4a2c9d52f66e6149c32b57d4e83e65bc8deaf01f121f1d9b4b267546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36212046310d596d1b74e5f9209762871f9690ef4df027ff428839a9511e9d31"
    sha256 cellar: :any_skip_relocation, sonoma:         "d706635341c2185fb17dc9111eb9cdd476f41dae3853eb2948d68d33f90ba0be"
    sha256 cellar: :any_skip_relocation, ventura:        "7b8473a394724862d47527e7f33a2f710908a49c59c1d96227f3d063838972c6"
    sha256 cellar: :any_skip_relocation, monterey:       "309cbba2947f2b69f8957ee157023f4432e90ee7485ba6def2aa0354faa7725b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33670fdac96bf34e0d9f69102e3ffe13c7dcc721c5510d7c532b15a53f00152b"
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