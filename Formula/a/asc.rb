class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.36.2.tar.gz"
  sha256 "878eaaa6729e436127d769a754bf0fcc8cedffdc2b292721b953036c0ae6cc9a"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4283b508a17a55601dfe0cccd26ebd041d5357111f259f71b0173a929d333057"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2b1f4ad55cd480453a9c08c683aa5b26b623d6a0f059f411beb20e9c6f1c965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "070432dc3a878da592d41aee7df4d84dcf3ec5ea49a3b096236a312202a3f7b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "26a98efe63cc9e8182b85b81be47988417772b2ac5f139cfc4706eb421a7c155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfc5f53b246c0c6be01f092dc036217eb2df027e194253e7f2bc99d17aa501c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e58c50bcbebfd368f13e8b65ae16460060851470d51908677bba174dd8c74a"
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