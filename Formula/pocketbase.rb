class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "28f9de0e231e304c49d9169603d67efb50362de691f8f3bf493cee3fb08808bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2af401425fb7241f206467cbb5d2ec5b55e15f50942048b2b19575718b6ca730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af401425fb7241f206467cbb5d2ec5b55e15f50942048b2b19575718b6ca730"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2af401425fb7241f206467cbb5d2ec5b55e15f50942048b2b19575718b6ca730"
    sha256 cellar: :any_skip_relocation, ventura:        "a642f8aff3e11e3e45afcb998e4fd6c494e14dde570aa030a7a2fb17f94d5753"
    sha256 cellar: :any_skip_relocation, monterey:       "a642f8aff3e11e3e45afcb998e4fd6c494e14dde570aa030a7a2fb17f94d5753"
    sha256 cellar: :any_skip_relocation, big_sur:        "a642f8aff3e11e3e45afcb998e4fd6c494e14dde570aa030a7a2fb17f94d5753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cabc0049c35cd2baff9c6414598dec64100b308d50fb41eb333afef0446be576"
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