class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.42.0/cli-v1.42.0.tar.gz"
  sha256 "f04af59911f9448dddc3fad8a49532525444d13c3a053aa382142ca85566b7da"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6dbf504a53a65554b4112e5b2ab11ea6cd15bd9881360441a957078357359f82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4845c848fd55c3c46bd9bdc6a2779004b32a432dcb0a16813fed8e8e91f76d7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45a84d3f2139d8f3f4a41c03818e1e14f53595a102949f4735f6ebc650e6a210"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc525d443c4b63868e54f5fb6748708c1e162d885bdcb882022cfe66814ad2b7"
    sha256 cellar: :any_skip_relocation, ventura:        "fcdf5267de0a97fee3bc9b705299ca9160ebdbd802ed0a768e1bf8016960e308"
    sha256 cellar: :any_skip_relocation, monterey:       "919b79e41343515a70cca5c8a863f7d2a5d270bbac24a73c8c07d02006f3a4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba150920e0beca574861a01d5475add90cfc0fafceeb63c9cd30384279668707"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end