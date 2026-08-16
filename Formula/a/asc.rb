class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.4.2.tar.gz"
  sha256 "e0c9699ebe6f848e015c878f4f21d48d40d52c37515efc838a44d0d6fac74747"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac0dfe2bdc5bf284e17d13b208635faba282db31c54443ce3473b470a6046a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20f365e2d24a2780a21b52496a24e00835a24b877bd2e8057d5361516af1b099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eab46ad30ca81a1eb74140ada14384fe756a4dd37463e5ec84fddd2a9570ee3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cb2a3ca96bb3fd5d25d5c3dcaa1ab927b264c062e2c0143393a7e2633f737d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f90f8a0f5c969aa3480e480116f904537a90e3ed5ef6005c434f2bdac15ddb"
    sha256 cellar: :any,                 x86_64_linux:  "c0552a8b17ef4a6d846ace5a80719710d7a35a65d71b5399c5336fe18c4e75f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
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