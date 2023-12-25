class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https:github.comkkdaiyoutube"
  url "https:github.comkkdaiyoutubearchiverefstagsv2.10.0.tar.gz"
  sha256 "8be067f468178b381391f091d7efc5aaa017b6ec7bd9b5f5bb4151443b37176b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06a01fa6f9893da188d930bf9970a767706c0d7e95507a0bd82f91e4e6291096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06a01fa6f9893da188d930bf9970a767706c0d7e95507a0bd82f91e4e6291096"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06a01fa6f9893da188d930bf9970a767706c0d7e95507a0bd82f91e4e6291096"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d5c593ffe420c6e38444dd867824a558ca92230ea9bc92f9ba5b7125beaa8ff"
    sha256 cellar: :any_skip_relocation, ventura:        "5d5c593ffe420c6e38444dd867824a558ca92230ea9bc92f9ba5b7125beaa8ff"
    sha256 cellar: :any_skip_relocation, monterey:       "5d5c593ffe420c6e38444dd867824a558ca92230ea9bc92f9ba5b7125beaa8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c66ab4f3d73691e56d973022b1252b0795472b9831b7ac4273e0f5ec67beb445"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdyoutubedr"

    generate_completions_from_executable(bin"youtubedr", "completion")
  end

  test do
    version_output = pipe_output("#{bin}youtubedr version").split("\n")
    assert_match(Version:\s+#{version}, version_output[0])

    info_output = pipe_output("#{bin}youtubedr info https:www.youtube.comwatch?v=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end