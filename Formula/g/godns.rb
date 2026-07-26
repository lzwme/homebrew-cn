class Godns < Formula
  desc "Dynamic DNS client with multiple providers support"
  homepage "https://github.com/TimothyYe/godns"
  url "https://ghfast.top/https://github.com/TimothyYe/godns/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "0edb5b0c82da603a930c04e6745ec3d0ef9b7412ff983e4f4c86c7e28aeffe08"
  license "Apache-2.0"
  head "https://github.com/TimothyYe/godns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b77ad19d7b06bb12f23a78245a074dad59e73da58ef253eddec37bab400ff98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b77ad19d7b06bb12f23a78245a074dad59e73da58ef253eddec37bab400ff98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b77ad19d7b06bb12f23a78245a074dad59e73da58ef253eddec37bab400ff98"
    sha256 cellar: :any_skip_relocation, sonoma:        "8015dc51129c482688544b2754605198ee84f2af5a3ee928abd134006a30fa51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe873e5df7f587c223ff3413adaaae3aa900f39947cb2c01bed5d8acf6f83eab"
    sha256 cellar: :any,                 x86_64_linux:  "26f9435c6b832d930c62daf7a2e2835f0fdf0b2b9d73b6838e76d5f8591552a6"
  end

  depends_on "go" => :build

  resource "web" do
    url "https://ghfast.top/https://github.com/TimothyYe/godns/releases/download/v3.4.2/godns-web-v3.4.2.zip"
    sha256 "fba1e397785b71a27ad3ca08d3f6205aef294dd4bd72baad5c019ac038377c95"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("web").stage(buildpath/"internal/server/out")
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "./cmd/godns"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/godns -h")

    (testpath/"config.json").write "{}"
    output = shell_output("#{bin}/godns -c #{testpath}/config.json 2>&1", 1)
    assert_match "Invalid settings", output
  end
end