class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://ghfast.top/https://github.com/amacneil/dbmate/archive/refs/tags/v2.35.1.tar.gz"
  sha256 "2576832a3405c5011ad948cdf5a3c08e35158396bc1007cc95057047b68e81cd"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9551846172b0f8b00259df071e4ac9393d11662ec7c130b68d12b44791e898a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2ca1240705326660123bfd58069140d0d5ef2dc61e8b84b533b0fbb7f1a05cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd0c9a8f740b61ab3ac0cedd7f32a33b32ed9ab7a5d64f4a130537280fbf2b32"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b4caf68ad0b5dfbbc25be29d5bbdac7ee276c2d8049b81c55f9464787ed9510"
    sha256 cellar: :any,                 arm64_linux:   "91284e4c1c9300dd098e240627ec137b2deede0503a6fe3e54c0db632728a5ff"
    sha256 cellar: :any,                 x86_64_linux:  "88bc5469aecd804b675b35a7a8b627fa095c6ded286441b0d5a85f02e16e9721"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    tags = %w[
      sqlite_omit_load_extension sqlite_json sqlite_fts5
    ]
    system "go", "build", *std_go_args(tags:)
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_path_exists testpath/"test.sqlite3", "failed to create test.sqlite3"
  end
end