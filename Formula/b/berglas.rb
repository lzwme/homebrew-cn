class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://ghproxy.com/https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "f963e5bc1657df235a910954b0eeac161f44362cbc3a20860ace9cfa8d57ba77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0dc2e3e683a9b77da0d9755556deccb9eb9b26d92d03e44e33fe736e74bc135"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef5af21478f6d5d1f712513a2b750a2303a68afc33ba7e8e750e800984b9d0a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62ba74b650aa634a021a2c805c2faa8412210c87937c8a1fb21e0b79f1ef890a"
    sha256 cellar: :any_skip_relocation, sonoma:         "59619bd12842fa16143e354128201feb250bdd2a56662c5e5ea9e3619bd99fcd"
    sha256 cellar: :any_skip_relocation, ventura:        "6d74c5d7577d1ce0640f89f5cf4ebc0b33173d9c811e5eaecb471b38d5817e2b"
    sha256 cellar: :any_skip_relocation, monterey:       "592fd28dadca03d22629c7e5d81b059abfee78e5c4e5da73aad8839242bca217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631933507a91e446a965421c86cbf6ed13e5b4e3fb92983dc63494bf4082ae22"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/GoogleCloudPlatform/berglas/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end