class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.33.1.tar.gz"
  sha256 "8497038f19cb650267c29d8f1c0fbc704b560abb49a362bdbeb20406aa1bf1f5"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "344b8acaea41a7221c514246e4a410c91514dcc374765a1e7d61d860c2f50f14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbb75e4ca32a934f00fb65acb0a0fbd7749f511755e0a2afd71fdbd398ac6b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92225adcc12687ce0acbc3ad3469c23afcc2fdb109ab500b22f4571cd147e914"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b2cd95ef5eefd39f38306675dee7cb589f6222f1eddc12f4caaf3928f227a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0159b0e4ee43b5ed8df98107bb61f76ff6c7359ba35e9875d365c4c0e010493b"
    sha256 cellar: :any,                 x86_64_linux:  "b760e99980597d038262695315b1569734a61cc01b4e3ac0380f93d6e6c4b8d0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end