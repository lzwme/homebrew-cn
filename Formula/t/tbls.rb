class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.84.0.tar.gz"
  sha256 "8c1cc0475bd4e1524da9522c19a5165ce5d3e36fcfa637b2d4bf47c002114c67"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36b8b349ed40eac85fb8b8fd40aea2c326fb6bbbf393ef8b59e7d325d76ac6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0430b76a186b8ceb76529e8440a8b5f85f84008ca185c108bb1c236f48182e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c17022c7de7533840b3662db1d41dad79fafcbbcf616a316eaaa029c8cc31da"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14f258ad4b044bc2f1eea2f548709105a180761124c7f3888714f07ee621dcc"
    sha256 cellar: :any_skip_relocation, ventura:       "7089671e8e614bf3f017e1b12bb1d855f098c91cde0f4b6c161a49bbbfe3b253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf1b49421470dcc5dc638e616160215dc9ebb7c54beb39eb05966ffd71bf651"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end