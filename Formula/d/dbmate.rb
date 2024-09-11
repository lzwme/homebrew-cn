class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https:github.comamacneildbmate"
  url "https:github.comamacneildbmatearchiverefstagsv2.20.0.tar.gz"
  sha256 "83f2af9db8e42fc2fc034b5da7aacd9b197f232cc4fe27b090e7a6f364f49fbc"
  license "MIT"
  head "https:github.comamacneildbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "27d437fd38fba0faad667d1efd14775a0c2e74cc42f5f697abc4d13f0b4e0d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b154ce3d8cfcaaa41dd86a04134b2cd17b04bf4e0790cf24adb89a5a57afd5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6b9557573f1c740145a7e99bd8003c0982401eea29af443f610f1bf2012bf1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "767d4e0314fbbbb48c7fa5d92b361e59afb24a38bb8ac6d7c27178cd135697fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "d457099db3005b84f3a734b88c32b8b50ceb8b860c7918b065914bc6bfbabd5d"
    sha256 cellar: :any_skip_relocation, ventura:        "d53b8f2738ea0c4ef3629dfb57b8fd4d78e517e6c36667fe59444730bbd6a46d"
    sha256 cellar: :any_skip_relocation, monterey:       "a40ce1f1750c5e6f87f8b384c2ba53ed7bed3961b501f29fb0e5b23ee4394126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7850093d39a766b2071e34fe6c3e1695179dd4e4c6ddc6364157dfed2cc4d186"
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