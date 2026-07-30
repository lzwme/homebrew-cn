class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.2.0.tar.gz"
  sha256 "b699b50d27156a8cbab302c425d629a286c8cae721f8c938f41e84c92b58b912"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "997e176f2aba0ccc9a86007eca0893303612aa98c5f57dbd94282e5bb21bce65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "289bdd4f7f810a4bbea2dfe3b5b4a94b63a1702b5d180fc04412dfa99152000c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59b1c4ae167c8e1943bfa94f688a04b2232b28eda4aa3fea1ae82474e88602ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3f1acbb31bc939dc2aec851f7f558717c1919b07f1a961f046fbe81d835344a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5432e22a18c9c2721b7a2697802accd3d987bb0015fa1da43e1d97b4622b9061"
    sha256 cellar: :any,                 x86_64_linux:  "b41b966081abb8a084702d9f0bafdc9e3ff68068b770a3e9d9c1a5a9a19132de"
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