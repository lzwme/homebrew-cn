class Godns < Formula
  desc "Dynamic DNS client with multiple providers support"
  homepage "https://github.com/TimothyYe/godns"
  url "https://ghfast.top/https://github.com/TimothyYe/godns/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "ba727c4770b80e86e43d5f724750d8a815b6e8e15844981552ad50d2f3c92c69"
  license "Apache-2.0"
  head "https://github.com/TimothyYe/godns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3348a8429ddd56c530cfcbb14cc8a41539a2142508f8a8e8b8a7f3debd30ea2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3348a8429ddd56c530cfcbb14cc8a41539a2142508f8a8e8b8a7f3debd30ea2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3348a8429ddd56c530cfcbb14cc8a41539a2142508f8a8e8b8a7f3debd30ea2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5ef152afc2b521419df7a66b1e0429e84bdc36a45511a662acc56335132e4aa"
    sha256 cellar: :any,                 x86_64_linux:      "2ae164bd399a532555da3802d2a8b1382de9aa6b582797401ceb5649a3a44a53"
  end

  depends_on "go" => :build

  resource "web" do
    url "https://ghfast.top/https://github.com/TimothyYe/godns/releases/download/v3.4.5/godns-web-v3.4.5.zip"
    sha256 "2450303336ae2e5bc71c2fab7b3e08e69054b0362505f3724e2e1462c7020146"

    livecheck do
      formula :parent
    end
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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