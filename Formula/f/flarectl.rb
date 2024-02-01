class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.87.0.tar.gz"
  sha256 "d5933abc91118236a8db6deb17879290a6d7969dcb98219c55d3a4aadef25a04"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9520b309f8ac38890f37a3f0381ded827bf99a479cbedc7c93697ed1d435486a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35cd8501ea5e204adb6e5e11b50b8446d7224631ffcd2e3998e1b7b6ff265e6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97e9f246bff655eea228a20ff3bf77c9262f1240143aea6c40124b0735a1e21e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a72057ba2a1ee5c45b1a0248d91c146c466380aef1b9a2c934c0a5454aafa18"
    sha256 cellar: :any_skip_relocation, ventura:        "4e44b749942241350d5fc384fb52519afedc032ed32a78416df174e3238b3cf7"
    sha256 cellar: :any_skip_relocation, monterey:       "bc91bbb55b895df65eaa53a380d7835e3c4fb2ec14287d2aabb3237bf63e63d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32651c717e91af233ef197e29c2ffb3844507275315e3e4e7022a2dd7f215da1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end