class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https:pocketbase.io"
  url "https:github.compocketbasepocketbasearchiverefstagsv0.20.7.tar.gz"
  sha256 "2643f2ad1ec7981f554e4aa7a71a237016ba3814f4b19e7be4b02f8b0d5334cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e917a47bcc9e3c2a73a5aae4f25764dc633b51f5fcd8c12e40b5949fb0b3201"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e917a47bcc9e3c2a73a5aae4f25764dc633b51f5fcd8c12e40b5949fb0b3201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e917a47bcc9e3c2a73a5aae4f25764dc633b51f5fcd8c12e40b5949fb0b3201"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a29fd1e6c9a96496f5973ecb5787ea090585c047eb628b6f02218b3e6099efe"
    sha256 cellar: :any_skip_relocation, ventura:        "8a29fd1e6c9a96496f5973ecb5787ea090585c047eb628b6f02218b3e6099efe"
    sha256 cellar: :any_skip_relocation, monterey:       "8a29fd1e6c9a96496f5973ecb5787ea090585c047eb628b6f02218b3e6099efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ccd334ab6871dd38be2b39ef51391dd9645ad888749ab7806b3834e508330a4"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.compocketbasepocketbase.Version=#{version}"), ".examplesbase"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}pocketbase serve --dir #{testpath}pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath"pb_datadata.db", :exist?, "pb_datadata.db should exist"
    assert_predicate testpath"pb_datadata.db", :file?, "pb_datadata.db should be a file"

    assert_predicate testpath"pb_datalogs.db", :exist?, "pb_datalogs.db should exist"
    assert_predicate testpath"pb_datalogs.db", :file?, "pb_datalogs.db should be a file"
  end
end