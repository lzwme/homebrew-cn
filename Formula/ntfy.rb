class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.6.0",
      revision: "64ac111d55383c4d73adcf8cd2a52e2d5e4df625"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61a94ababe934fa9a5541f156029b9cd37cf529846e8fbf5c7c5bc2776aaf703"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61a94ababe934fa9a5541f156029b9cd37cf529846e8fbf5c7c5bc2776aaf703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61a94ababe934fa9a5541f156029b9cd37cf529846e8fbf5c7c5bc2776aaf703"
    sha256 cellar: :any_skip_relocation, ventura:        "1445ac2f096c1ebc6165be38eeeba4fc3a09ccbcd7ca97951f99e96eab49d87d"
    sha256 cellar: :any_skip_relocation, monterey:       "1445ac2f096c1ebc6165be38eeeba4fc3a09ccbcd7ca97951f99e96eab49d87d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1445ac2f096c1ebc6165be38eeeba4fc3a09ccbcd7ca97951f99e96eab49d87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82ee55db6aafc1d600c697083edfe565fba7b13eb4317845e35956f6896ad55"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.strftime("%F")}
      -X main.commit=#{Utils.git_head}
      -s
      -w
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "noserver"
    end
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end