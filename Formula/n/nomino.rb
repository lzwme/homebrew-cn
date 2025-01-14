class Nomino < Formula
  desc "Batch rename utility"
  homepage "https:github.comyaa110nomino"
  url "https:github.comyaa110nominoarchiverefstags1.5.0.tar.gz"
  sha256 "f309f2c31d83b7a75df287e72eb5d8296cba154d889c8a4e16e30c57eacbf6f6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyaa110nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34694a98bf124b01e41fff5b3a49a35d99fef94689cbb70c76c8f4bf1a480ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5badb410c8beb4e3eda0fcb5cb0dd03f8b6eb694c00d11e4eb08b68002f613b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a313335a9c567f12d826a78ae3d302c7e24d480dbf766779356e56dd4127244"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dafbb373597c74aff4fbeb01a7bc5ee6e44034083c7cf5efef5663d40b3b986"
    sha256 cellar: :any_skip_relocation, ventura:       "6227b4efba5464a1384fa615b8961aabcfa2538a1c95546836aeb95a9da652be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb3908457f77050e7c5964a8c5d623f50f3e9e71c4ca52bd7233d4049afc9d16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath"Homebrew-#{n}.txt").write n.to_s
    end

    system bin"nomino", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath"#{n}.txt").read
      refute_predicate testpath"Homebrew-#{n}.txt", :exist?
    end
  end
end