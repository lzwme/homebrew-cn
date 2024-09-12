class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.23.tar.gz"
  sha256 "e28f63736d7c11a25349ee48b0118e1cba16d11a464dcadca2d947c77bc8cc83"
  license "Apache-2.0"
  head "https:github.comrefaktorrye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4383a4110a96444282cf9f075fec1b7df200712bfb92742f4feb36f9f226a6bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3a645ce39bbea36b375f2b513e693902b602db9122b0abed56f76afd1913e29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33f1bd18a0f6dda79ca34338c41ee4512b81a05e9cf7750490627b499af4c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb6ae42e7952351ff38fb46cf19f5b8685c0e55cb1ec265ad3ff521d76300013"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb0cab0332aebf2b4717352efaf764caa2617d85a383c1bf0e11d5d15048555e"
    sha256 cellar: :any_skip_relocation, ventura:        "73f61bfc058e384dc9c458ebcd128d951711079f413076f60212bc9f95773e74"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd3b84691a7102b84a214664c5d415cf3f7700dc75d3c2b8d8c5b69c54cbb10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99905a85a31858ebb9384f40a7eaf63fe8b067b8eae939b26e3eec749d025bb1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath"hello.rye", :exist?
    output = shell_output("#{bin}ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end