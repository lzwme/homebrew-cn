class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.37.1.tar.gz"
  sha256 "02da57cd19a0833f6db887c09822eb88e75f4b360f715c8f3f6e00c223d81632"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d256b84ef7f215030fd8aba18effc858ea35693dbe5857568aec37628788ecd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c78b809b0007a611f3c2932c20af4d0a59f6d7da83bea83ef7ccd4292e22d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc2e6bdb0358f3dd74efb717b9f99b9716e0f811d761bbef51b219a1ef5d46f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d87c62a838f78b78132b4e7f1713c85dfa3e52285a5b2d1b7312d295497a48c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3540328080e91ddeb7d42edb6758d298e384553d45ed641f70c3c68b4b5129ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c2a1f4e9be17f02cddc1d304d8ca72eb526db5097e7f0acd214e0580c6ecd9"
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