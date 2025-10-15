class Dnote < Formula
  desc "Simple command-line notebook"
  homepage "https://www.getdnote.com"
  url "https://ghfast.top/https://github.com/dnote/dnote/archive/refs/tags/cli-v0.15.3.tar.gz"
  sha256 "e3fe1ba082fa3ecaca42a734149a00d4b1fd48b39a14245f26ec5f3fc5bd1bb9"
  license "GPL-3.0-only"
  head "https://github.com/dnote/dnote.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b829fec07d5ee3fbab45f2c8ddc25a54f0278dd1fb25953674d1959f493e31e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "702adaeeb766a1fe713bb262f409bf96b3afe162e5b7e24c3ded6db1bce1a32f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2b8c0527ab722f773a0217f6340c889f8a56ca9954a21e7dcb6f918fda0dc7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b571f4cd5e31c846c955c45bb246e251f4a073d05eaa37f2b1f4210d448924f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2271fa682e269d6411bba2f124ccccf3c40ee59c6d9ceef932ae04a03a733d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7267c840340c83202c15198bb678efcec32c4d5a469ad62be8e7ad651e9c987a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X main.versionTag=#{version} -X main.apiEndpoint=http://localhost:3000/api"
    system "go", "build", *std_go_args(ldflags:, tags: "fts5"), "./pkg/cli"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/dnote version")

    desc = "Check disk usage with df -h"
    system bin/"dnote", "add", "linux", "-c", desc
    assert_match desc, shell_output("#{bin}/dnote view linux")
    assert_match desc, shell_output("#{bin}/dnote find 'disk usage'")
  end
end