class Apigeecli < Formula
  desc "Apigee management API command-line interface"
  homepage "https://cloud.google.com/apigee/docs"
  url "https://ghfast.top/https://github.com/apigee/apigeecli/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "61d441d082d07dd7102483dea826fa57dbd97d76434076312a67b067776698fa"
  license "Apache-2.0"
  head "https://github.com/apigee/apigeecli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "498a7ccc309d4d391e5ed215937bc461438c4ff94449eeb75a7ce726355c8028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "498a7ccc309d4d391e5ed215937bc461438c4ff94449eeb75a7ce726355c8028"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "498a7ccc309d4d391e5ed215937bc461438c4ff94449eeb75a7ce726355c8028"
    sha256 cellar: :any_skip_relocation, sonoma:        "6769094dfa947b204f4fca357ed7af5ad35d8b5ced4a4cfd181e8f36bbaf87f3"
    sha256 cellar: :any_skip_relocation, ventura:       "6769094dfa947b204f4fca357ed7af5ad35d8b5ced4a4cfd181e8f36bbaf87f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be1b087aa21bf3dc2011b030f15ac1324f01c0010e02539fb29d3de1d4148d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4fad1d8ce752aa79e4c7433aa12f5c5a2e1a3b4e50c7af29a9d79d830ade158"
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

    generate_completions_from_executable(bin/"apigeecli", "completion")
  end

  test do
    assert_match "apigeecli version #{version}", shell_output("#{bin}/apigeecli --version")

    ENV["APIGEECLI_DRYRUN"] = "true"
    apigeecli_apis_list = "#{bin}/apigeecli apis list --org=homebrew-test --token='homebrew-test' 2>&1"
    assert_match "Dry run mode enabled! unset APIGEECLI_DRYRUN to disable dry run", shell_output(apigeecli_apis_list)
  end
end