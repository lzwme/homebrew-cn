class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "01ddb7380842dfe014ba28296b30a758d0b9217643a7b003fe4c1ab7c82f39f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "484506f8733e9cd498852f8b3f09b2ed03d215758bbdf95b1592b32742cf6773"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "484506f8733e9cd498852f8b3f09b2ed03d215758bbdf95b1592b32742cf6773"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "484506f8733e9cd498852f8b3f09b2ed03d215758bbdf95b1592b32742cf6773"
    sha256 cellar: :any_skip_relocation, ventura:        "1204efe9e1eb03a56d9c838326ced5daa9bbbfa07fb40421d0856073919bc33d"
    sha256 cellar: :any_skip_relocation, monterey:       "1204efe9e1eb03a56d9c838326ced5daa9bbbfa07fb40421d0856073919bc33d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1204efe9e1eb03a56d9c838326ced5daa9bbbfa07fb40421d0856073919bc33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4decea7364aff1c5d1efd5033095e3786cc5144cb5a2a5151921ffdf73521fa"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    system "#{bin}/pocketbase", "--dir", testpath/"pb_data"

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end