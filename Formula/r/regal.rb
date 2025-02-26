class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https:docs.styra.comregal"
  url "https:github.comStyraIncregalarchiverefstagsv0.31.1.tar.gz"
  sha256 "28c93cc79351ac2430349821b1a6a8ba00fc5812f2ff5a16d8d4de77ecd2aad1"
  license "Apache-2.0"
  head "https:github.comStyraIncregal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9cff8762c87befdbfea05a8f35847c27b8df5895f1c42577d2603dcf801d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c9cff8762c87befdbfea05a8f35847c27b8df5895f1c42577d2603dcf801d04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c9cff8762c87befdbfea05a8f35847c27b8df5895f1c42577d2603dcf801d04"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f0faa953233ef82693423936648f019f052760486ef4b6ad8e00dc88ecb1e0f"
    sha256 cellar: :any_skip_relocation, ventura:       "4f0faa953233ef82693423936648f019f052760486ef4b6ad8e00dc88ecb1e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3403198ae1fa6ca06d6c0f67fffb7c038adf171a3265f54116ad76be6f31862d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstyraincregalpkgversion.Version=#{version}
      -X github.comstyraincregalpkgversion.Commit=#{tap.user}
      -X github.comstyraincregalpkgversion.Timestamp=#{time.iso8601}
      -X github.comstyraincregalpkgversion.Hostname=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"regal", "completion")
  end

  test do
    (testpath"test").mkdir

    (testpath"testexample.rego").write <<~REGO
      package test

      import rego.v1

      default allow := false
    REGO

    output = shell_output("#{bin}regal lint testexample.rego 2>&1")
    assert_equal "1 file linted. No violations found.", output.chomp

    assert_match version.to_s, shell_output("#{bin}regal version")
  end
end