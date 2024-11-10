class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https:github.comamacneildbmate"
  url "https:github.comamacneildbmatearchiverefstagsv2.22.0.tar.gz"
  sha256 "7a6b0097a44eec2f8f833a549bc3a8b2136b4825870b97a9318a68823a2a2583"
  license "MIT"
  head "https:github.comamacneildbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70067f63cb7cf45a3b36fc2f8689d692cc8465754b804a362dd97d0b692b2f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96736d9851efb711126e455e317d2b992d37fc23cd1c280daa353d6875693467"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "849cf7dacdf4b3cb07080a1c8cd0eab2ceaa06d3148615bd4f47a68b9c4e81a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "420ac75422b387ebc813948c60dd12fb9680b92106327587ed54de64c23b56f5"
    sha256 cellar: :any_skip_relocation, ventura:       "37d93b4f5da6eb64891500c8d84a306d2c9d75d9f1707f91ad5a2a5b615646bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed6e8c5993b55973bb3af7bdf0ca447194762b4d0faaf0cf11745b7b622b808e"
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