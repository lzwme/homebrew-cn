class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://ghfast.top/https://github.com/amacneil/dbmate/archive/refs/tags/v2.29.5.tar.gz"
  sha256 "55faf8e2751efa81b4c135a5411012a0cea80a60c29e8c7be6f5e777aa4f3706"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79342f9ac7f1dfd1ed0cd77ad4ba4a964fd5b8848016ada26c3d2876d1437f92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8af4ae9d650c05c5a1d7242c6c989251539bb17f3979ee63e40c37aec5efda9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f5524aa48c5b065a3f7775abb303e97bf1f9b7ed9a009f3b61f9061e2f08326"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c3d6763bbf2a91e4678cddd5c983fe64299bec0dbee57431b76fddf8bea699"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf93e10b9770cdaa9fb3f8f0735e13b5216839304ede39e6d7807e8c377dc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d906e5bddd689f9e2fc557554ede1dea0ea6529d3a5c9e725ad71f51b464911f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end