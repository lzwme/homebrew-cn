class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.7.0.tar.gz"
  sha256 "16f1550faf8c0eb0f057f2a8958b3bb6546e281afce3c1d29a0edfd4ba50419e"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "910272641cfad8bbd82c901f98e0fff0c9273b2ff440f022a48ff91769b46448"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0398adc5ea2d6ba7dc949f52d6692f706ddc6c4c29c3ccaf3fedf4d4c936641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fbae2f412f95872808cc5ba151c43da47af2bea5c483dc383a9404fe5891233"
    sha256 cellar: :any_skip_relocation, sonoma:        "69772c86d55982ae97369a737bf55e5f0d9ba8689a2913356580b74939ab1ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba5ff63411a2730beac27b456134ee7775dac871217c060d600951b9918ca7d"
    sha256 cellar: :any,                 x86_64_linux:  "9c7765f15d704cfd7976d381ad94b5d4a0efeee24fe9985e58f2f8171d50f1fc"
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