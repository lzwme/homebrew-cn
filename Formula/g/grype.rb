class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.80.2.tar.gz"
  sha256 "ebc6562a6e3f0468ce3a6f701d850a1ac363f4136409c80055abaee04cf4694c"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eb9c78895b715aa7bc943a8e676254313291c40f13bd38fc71c22c0325d9975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "711de3e2a7cfb34db8cd60328c5bdfd4325570697905080d1ca3f159253bc989"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5a99bacd776133d4028c159c600cd3b5d8faf1ac6bfb37eff91d70085335cdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "29ddfec33481331e30658e6a1184ffa90bb571c9c2b0d2a8c82efdea0715b3ae"
    sha256 cellar: :any_skip_relocation, ventura:       "d3a617dca30e5e5fb16d24ddab454987c3b3a9d215c903fdc84899874f61332f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0b25c6d3ed6523ea7444dcea02404fbb1d6b2a07c778731644a314f2f986b94"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end