class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.91.tar.gz"
  sha256 "0357a050f8339cd545bef2cc87c3c0222f670bb83647eb5a055a077938028dc5"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbd445876915a6f1ca6cb726c94c392e7f5ceebcdaeefb408e7923a7f4cc1e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbd445876915a6f1ca6cb726c94c392e7f5ceebcdaeefb408e7923a7f4cc1e47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbd445876915a6f1ca6cb726c94c392e7f5ceebcdaeefb408e7923a7f4cc1e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "e03f68020feb2d39cf648d4b595211677c3d792acc3c4302c2aa3924197c0fa4"
    sha256 cellar: :any_skip_relocation, ventura:       "e03f68020feb2d39cf648d4b595211677c3d792acc3c4302c2aa3924197c0fa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17fb610e017364be00344738c2240c52c440e61e1ceb40201d688914ad8a2844"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end