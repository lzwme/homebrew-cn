class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.92.2.tar.gz"
  sha256 "068f4eb86146c917f29372dbdcda42f6a59a56a70841f3aa48021cf49975accd"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e775c0bb0abebe003d30377667ad4560ed80b50cb4aafeed146412f3c4f800a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d8de514eb4ce7828974010bdef0868c108ba1de054255b8518f10cbf781eb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b986874d4a28f807828abd6eaf12d481cdc6b93c376d9cb612120624cbc48897"
    sha256 cellar: :any_skip_relocation, sonoma:        "927f7cb508009725263811270b5d0ddb5beeea74d4e23a94a970a574a35203e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5283b61c4ef109226ffa79b5a04d112450ec30ab0616dd350893918e3fe7447e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9acb9001574bfbe444140cc500f888e4c55759af93cdf4733818af165485d4f9"
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

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end