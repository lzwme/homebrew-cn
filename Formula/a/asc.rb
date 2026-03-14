class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.41.3.tar.gz"
  sha256 "dd423b7bf4cf5007381f851ea5559e06fa7b7d6fe8cdc1f302b6341d6c558a03"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfeb5add0e0c90887c75da84c4ae52c8ea500bb3d67093429c30ee630444087e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c6fa65b913eaf7b73111fafadde7655de28c8265d34eb20757960defdbe990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c11d56b1fbf42c52a9f4034bcf56e9789d5dddeb90c5d96fc4095eb424bfad44"
    sha256 cellar: :any_skip_relocation, sonoma:        "7718dcfe1aa253d9d94a798b054cf6aa8f16cccc3f6e6a858997c10ec46c1716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc62578d41c636fedb7214f8573efd61415cd9cd9ff40b579e676cf74c410ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cae34d8b151e88ebff8cbc11480fc18d166508a6e3a5c2ef06df058c4ad4eb01"
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