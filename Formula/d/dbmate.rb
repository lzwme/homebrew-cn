class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://ghfast.top/https://github.com/amacneil/dbmate/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "dbfa6f9ec7faf859352eb329edd937a86a2c9561a4d45a2dfd024fd54634bc78"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66c066a3eb29a5ba04012056dc20f61cc3dea3b0384b0c23887c8394f633f680"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b9109a4a1b3c42322fe7a7c72eea1d28844ef92ab42670d702a14132ae3156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "517f49f7086241f2b25c4520ddc08df516d71ec51ccccfe3a66da9dee953447b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b62a9059196b2b19c9b61ba9703f6563ecbefed36b9df5d931ad8654b9c3a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4e9db937b1de507f071d771a6d9d0d5ca45d4a62c5fed6c26a217e9fa0c5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f97a0411ff8292aebc86169a2002b3e9a12b755cf1df18e3dc9508df7f899c2c"
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