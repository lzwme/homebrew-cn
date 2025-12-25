class Apigeecli < Formula
  desc "Apigee management API command-line interface"
  homepage "https://cloud.google.com/apigee/docs"
  url "https://ghfast.top/https://github.com/apigee/apigeecli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "eed2a51199b7778e2faf1752bb8a8f3bb8d60240f6159152fa9d95f5cfacb534"
  license "Apache-2.0"
  head "https://github.com/apigee/apigeecli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3e2dd0b50dfbeed437c7897cd71bfb03890c689bf7e7695ba78db62b4fa5810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e2dd0b50dfbeed437c7897cd71bfb03890c689bf7e7695ba78db62b4fa5810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3e2dd0b50dfbeed437c7897cd71bfb03890c689bf7e7695ba78db62b4fa5810"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d490559e0593a3ae111edf348f93c8b31ff47614b0990ac03225ad8920ee01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68a5c4d374adb32b6d0ed07b96c721572a1298c96a0284a67746e48cd3a3776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a9e1da29957d72e9ba561b9eda0d1752f8b7d2741f3631a78ced2f397cc4ca"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{version}
      -X main.date=#{time.iso8601}
    ]
    gcflags = 'all="-l"'
    system "go", "build", *std_go_args(ldflags:, gcflags:), "./cmd/apigeecli"

    generate_completions_from_executable(bin/"apigeecli", shell_parameter_format: :cobra)
  end

  test do
    assert_match "apigeecli version #{version}", shell_output("#{bin}/apigeecli --version")

    ENV["APIGEECLI_DRYRUN"] = "true"
    apigeecli_apis_list = "#{bin}/apigeecli apis list --org=homebrew-test --token='homebrew-test' 2>&1"
    assert_match "Dry run mode enabled! unset APIGEECLI_DRYRUN to disable dry run", shell_output(apigeecli_apis_list)
  end
end