class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.93.tar.gz"
  sha256 "906ac29f2da832dfac00a4f76cac22ca20069ef5e8c88d68d11adf379cf12c39"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de1b254a0a4debd907d5f67811d723fd574ea8adbb36ffd617e7001c9c28bef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de1b254a0a4debd907d5f67811d723fd574ea8adbb36ffd617e7001c9c28bef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de1b254a0a4debd907d5f67811d723fd574ea8adbb36ffd617e7001c9c28bef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e995eb93d2c9524ce4b9d757f34f5dbf8e881839670beb0fd3632d482e1cd0c4"
    sha256 cellar: :any_skip_relocation, ventura:       "e995eb93d2c9524ce4b9d757f34f5dbf8e881839670beb0fd3632d482e1cd0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e898af9318a68ab33786dd1da53e2e776a0abfe7ec63e288bc913c65f01f4e6c"
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