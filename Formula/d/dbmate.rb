class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://ghfast.top/https://github.com/amacneil/dbmate/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "3acfe82fd369cea1d0ae6c512092167090b82a69d3f8145406ba988ed67f834f"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54d9c413261c7e4e8ec2dbebf41de505916a95bf0c125bbe9a5fdeb5e2d32d3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bffb0e5a8106fbeaa87e812654af27450f5e73808c5cbaa35fbfab9df626b1a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c38abc81d4265cb124b5f4153bd92010ca6b9e17ac50ff199d87a11c99fc4160"
    sha256 cellar: :any_skip_relocation, sonoma:        "640ba997dfebc654fd8bb6be3006478b8ff9cd568307877453a57ce1eff943ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6434d133fa7b07ecafad2d5d57fb10481efb39809fd553598f0bebaca79f3a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abf0ae4437d19da792c6ed32009afa1100823784d8da6a2f6ad120fef4c1e88a"
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