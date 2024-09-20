class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.69.tar.gz"
  sha256 "aa599164eb5f78ebae0fc78482ace32e9f3f852f8af55cb3ae7f7e53c74ce39c"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a524ef54f97aad75281a7f0388e3327c05037a5c8aa5c2634a6e8dc34e028ba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6f9bc1554da87c4c0ec174a26c6dba4255d616aaf78529b699f918f1ac5cf41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44399e2d8ddcf0a7de93db893e30c75db8c2a6d38e674df8e80fd1f738db8df7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cfea96caa30aee71023c8bb9c80f88f69b637420a3792d59e4b1ec6c5745b48"
    sha256 cellar: :any_skip_relocation, ventura:       "a11d68fe2a82fdef497b34d2d6e10a98b834d582994222fb2109473154e6385a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6d27963583ac1bcc67bf0a3826fe717fb319169f900fd2cc65cb54536133d4"
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