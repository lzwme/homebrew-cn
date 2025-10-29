class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.26.3.tar.gz"
  sha256 "ac5257f4ea23f29d648f8f2ed2cb537db082d79102f3f0b5177016d7a8cae3a0"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "611d1d9389f2fcaa89b308ef3fb55789ebb406dc2fb5395978cc870fa39667c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c4dd4fe3c555e8da662d9b92a2920215a3623c0d6a4d7736d93259707bfc82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6b5841b96c3440bd24ffe1f191b9a5ced27a22531b3dd29c93405d222bbdd77"
    sha256 cellar: :any_skip_relocation, sonoma:        "4443f935b76310291095cccf5e4000eeda02e5f7b6604b90bfbc43eac5c437f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf18c6cab54cddd64c21d7f76e4e4dcb1e7867d9a82f25629ab49c24ab36bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba11a0c8c5a0f1d15c20af624895550e9981dff33e0134cabb50fe57bc20e1cc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end