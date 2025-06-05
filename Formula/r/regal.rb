class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https:docs.styra.comregal"
  url "https:github.comStyraIncregalarchiverefstagsv0.34.1.tar.gz"
  sha256 "bfb0f434e2e93eb84bf32f901366e3b04f1013d47b9ae6cfee16573e29edf907"
  license "Apache-2.0"
  head "https:github.comStyraIncregal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44088fc914e1c05ef95ef3ebd7ac23383788826b435829b702af62b3f7abb034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07bd8c1b100cbb0120b13a049c3090d9d18b9ed3ac9abe1b22ecf7180faffd48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a1593521e8a842e9366b4cce7621e148caf1d0d1a0b09031530850ddd98e717"
    sha256 cellar: :any_skip_relocation, sonoma:        "387176bd1e6e81bdc70aea92fbd394c3af2133374ebc549428aaacdf7e12de1b"
    sha256 cellar: :any_skip_relocation, ventura:       "4aef271ea38608a5ad454f4be7306586468108ab91f53755341468b781ed137e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56abfb2d4870d59e92639b7e08096302972ab07b5700ff4703e47c8471ba1a43"
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