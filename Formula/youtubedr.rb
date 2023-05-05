class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://ghproxy.com/https://github.com/kkdai/youtube/archive/v2.8.0.tar.gz"
  sha256 "6ed95fb487eb83fe46aaf5ba02fdaa8ee123f5054bcf74497536032c9235e675"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80ac7dd559143e209124b67631a5b33bb64fbf3e1bc7c9e99f4a6abc7b3ab621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80ac7dd559143e209124b67631a5b33bb64fbf3e1bc7c9e99f4a6abc7b3ab621"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80ac7dd559143e209124b67631a5b33bb64fbf3e1bc7c9e99f4a6abc7b3ab621"
    sha256 cellar: :any_skip_relocation, ventura:        "5f8a70b9822bcd460975603e9c9d1f6ef160a29bcbe3433ddbf05988ac0b6aba"
    sha256 cellar: :any_skip_relocation, monterey:       "5f8a70b9822bcd460975603e9c9d1f6ef160a29bcbe3433ddbf05988ac0b6aba"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f8a70b9822bcd460975603e9c9d1f6ef160a29bcbe3433ddbf05988ac0b6aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235407cae80c06f255b2cdf976c8f5bf0515340b81e8e239e202efbcdb6bbcbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", "completion")
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end