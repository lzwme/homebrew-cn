class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.65.tar.gz"
  sha256 "44572d85bcc523f891adaf882a552758503431fa231351ebd73e305ad7346610"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "28ac1ee0e036dcb916af5ea3907fd5b0e100d941a37c4ce7871dfd61655e42cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a13c3167dcc757e91d536237cf0da891e5f59889a9e22931099a0ddac4aab9cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96252b1cf5e544d24becfd1d7d2720823169814c5c6b88a758dc0b5aed58f5a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b498aca7d915d3da5a8712dcb108487286fdd34d4e4fe9651c0f8e2c60be0c6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1183a1142bd43ff3da42607b3b14e6cbda0a24751f15a7b97326b6c991db0cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "e3d0c2ade2add81728e4be7c4b6f2ecba7c9c722a36c42938e5de60b05fb1d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7d36e3588f1c5d460ef334064591c86934b6a9059d02acbabfb0f2e29c0215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c44b08cdd1c809069e1aefd064506f8b007e48ec24cd172a181fc06f1d35bf0"
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