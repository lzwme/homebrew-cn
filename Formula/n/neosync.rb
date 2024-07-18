class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.46.tar.gz"
  sha256 "66d4e795fbd5ed392edc711201c0168d6226043d3bce3436fd4c4d20b31a3a07"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5990eefd41f26275a87923c8ab0803a9d323ef392f3a6ac56457f7ee71daed1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ff7dda579d99f5d0bd97ab084b5da0af4fa30ee8f7ba3005a0d0ce5ce3ecb05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c59d53b765e9ebe664e68a33122cf587898157a95493a7091a04e983ed96e929"
    sha256 cellar: :any_skip_relocation, sonoma:         "d34bda0709593441c7dcf58addad2e397171abf7e5170180d7790aae03816b15"
    sha256 cellar: :any_skip_relocation, ventura:        "96468abb03171737a2b62db0218ea9ee21965d38d522c87d0e1519089d5dab54"
    sha256 cellar: :any_skip_relocation, monterey:       "19eed9de2cd850df2f49578053f7378fd7180c954a6b14ab12c8f5f5e87de0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c99fbd83e48a3ab780f9a31b63d6c406a9f675b7ea58f97c2fe0c5bd00ef3722"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end