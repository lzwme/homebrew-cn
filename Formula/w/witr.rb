class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "5d697999be5684a2723d92e649a72c80ca2df464f6e7dcf5e52551b5ee9194fd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d1d87b6680102abefc57482c4b339733ce6f846520a64ed2514d24552a27a79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1d87b6680102abefc57482c4b339733ce6f846520a64ed2514d24552a27a79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d1d87b6680102abefc57482c4b339733ce6f846520a64ed2514d24552a27a79"
    sha256 cellar: :any_skip_relocation, sonoma:        "517bc9b81db2de6b2054e5b47a2091b2ad81ee445d40b17c3a3205e2fee9c538"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faab68bd4539896e97aff48f49cd42738538646036152c68e4c4bbc0d329c400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3236ab219398015a9b203973631df16f0ee2ee4c5585d5bd187b99e0b9ca189"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/witr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    output = shell_output("#{bin}/witr --pid 99999999", 1)
    assert_match "No matching process or service found", output
  end
end