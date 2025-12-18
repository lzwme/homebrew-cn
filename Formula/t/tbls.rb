class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.92.1.tar.gz"
  sha256 "1ce3c19cad9d0d96ed6884828fa15af7d88ed0fa6d01bc462239d5e0e232a27d"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03fa77c8d038e867c1ab86ac5918998ffa52354153082a23f31b720a6f98098a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9acb31e432c6a690aed5ccb9d0b04c6e9eb784c40b142d9115e0c75b9bd3d2bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d0480cff7474dc0a8331d67d5f504afb4bf68fd753341ff9171eb5bbef52d3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "62fb0d9dc913becb43c28efd6486f927d07f6550a5dbe4ac4e7a7536bbfd226c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2c4324e57a6a7c215b51128400bf7c4f006fa62f4b64a35b724ad095be71db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b3eb254929428f12a7cea7999cbaa0f68eb6f9832b5dea7d548242f742d5670"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end