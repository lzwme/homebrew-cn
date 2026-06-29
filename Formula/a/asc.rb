class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.5.0.tar.gz"
  sha256 "318f5f0aa6c63f1eb4e2d73b88f5f53cd86cfece22e7a940e552bab2f361f8b6"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5d79fcb4bc10f80488b8a1405c37c49c6cc8e95175912981eda34276f3814ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f4d0b20b8cb72591188c54dd30a4e99ee71e0f285e0f2539da537e5c5e8721e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79cb64d33ac0b3ab8338de6506026e8f11fd378cf509c6b356f343797e218b15"
    sha256 cellar: :any_skip_relocation, sonoma:        "4211aeed579438a56e29ed480ab883fe2a89962c28082d5500ea8fade3ff48b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f420ed01ac418696633586ebfbf94bc7d3a4ee757a545f47351dc5bd421394c"
    sha256 cellar: :any,                 x86_64_linux:  "41a8c2cfab54735064c5030421b5bd08e7954d232e8244896c057fb81a380e4a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end