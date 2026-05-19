class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.5.0.tar.gz"
  sha256 "ba55288ada417fa694c5b8ee5dfc36e2708167415da5efd7c0449b51ddc16e7e"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "742c4a515844c8c94acd812b155fa46da450258f83676c98fbb82fef0b1099cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf0a79e58aa2ef7729cb52039fe6da0ec97adc0766812f3512809ad6272a6d87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308c2f54f50cb40e689069ffe0d4d7b2965fba4a67e3a1389d1075336e3f76c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b7cc7bb869bf60095bafeadb6d1f7698c2b503174915a30c3751fb5f361f64a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98b183917bd6bf3f856339b3c3e57557169e52b8cc31192f9b22874b4c1c3e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58a7eb114b7731f6ebf29d7c086f7609833e1e09791ab42bf7ace49b4eeebe0f"
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