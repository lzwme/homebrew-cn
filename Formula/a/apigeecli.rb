class Apigeecli < Formula
  desc "Apigee management API command-line interface"
  homepage "https://cloud.google.com/apigee/docs"
  url "https://ghfast.top/https://github.com/apigee/apigeecli/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "7a0cb53288dfe15b337d2ba04344f3a4869fbf37481305ce36fad62d6a6b283a"
  license "Apache-2.0"
  head "https://github.com/apigee/apigeecli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "258f55c740b881c22285482b6a0d2a713c97ca2cd52fdbd1a689d837fa394f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "258f55c740b881c22285482b6a0d2a713c97ca2cd52fdbd1a689d837fa394f30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "258f55c740b881c22285482b6a0d2a713c97ca2cd52fdbd1a689d837fa394f30"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a4f0a97f6f04a978615122219da2ca29b2df163e8eaf3dd120cbaff7543b58"
    sha256 cellar: :any_skip_relocation, ventura:       "22a4f0a97f6f04a978615122219da2ca29b2df163e8eaf3dd120cbaff7543b58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e478820bcd12f7879496f9fd127a143ced123b44e4e197a5492afca25bda1806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3e93ca2622ce527dc0025ad466cb2867b6e8ca80f3d61ab4e6d1a6fed7f5346"
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