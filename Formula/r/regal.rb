class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https:docs.styra.comregal"
  url "https:github.comStyraIncregalarchiverefstagsv0.30.0.tar.gz"
  sha256 "1277ce36e84ef58e4777a2a763aab3255457487fcc909a6784959987808a08be"
  license "Apache-2.0"
  head "https:github.comStyraIncregal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "452f4b4178309fa8bff16289d922663f6b256ad69437adfb83ebf95b509b0e38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "452f4b4178309fa8bff16289d922663f6b256ad69437adfb83ebf95b509b0e38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "452f4b4178309fa8bff16289d922663f6b256ad69437adfb83ebf95b509b0e38"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e00044f776462d7263b66e7434fcd38daca6bc945fbd6620ed626e359ab04cb"
    sha256 cellar: :any_skip_relocation, ventura:       "4e00044f776462d7263b66e7434fcd38daca6bc945fbd6620ed626e359ab04cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "317e60f09a2c9cf922b7170bfd267ad500fee47e60c3e7023562f838eac8a625"
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