class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.71.tar.gz"
  sha256 "2841071901ed647721be6f2598e88679234d16a690d0aee4ec15a660c9f28e9d"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19779ff77509ac60d158f5d0b82b45f4a616674b05630776a6bc28a09bd766f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "053d0dc080af5f5878518fef7b3971a08650fad694e1446ef22d63aed524078b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2645792205fd0e4dbc120a8b556f4c320de79e215d33c35b0686db0ca7c89a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0179ef647593be8eacb1faa0699033cc6e27b83ba9294215831414638f8b930"
    sha256 cellar: :any_skip_relocation, ventura:       "e9b8e32b1fd6b5c5c56283263c7b3333b2f482fecb50a8db7b855e1da73d7d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1349bd7b71316edae4e9975c65d6153098cd2b85a89d15c4c800eca507428bf6"
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