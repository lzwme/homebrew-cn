class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https:docs.styra.comregal"
  url "https:github.comStyraIncregalarchiverefstagsv0.31.0.tar.gz"
  sha256 "0a79b76da09ffa79d4b77d6868deec646a05861c16e8afec61ff27d613f27bfc"
  license "Apache-2.0"
  head "https:github.comStyraIncregal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11c6065e1b04985e6fab3391a4a84ebee52e6f37904767891f6fe52784ab7570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11c6065e1b04985e6fab3391a4a84ebee52e6f37904767891f6fe52784ab7570"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11c6065e1b04985e6fab3391a4a84ebee52e6f37904767891f6fe52784ab7570"
    sha256 cellar: :any_skip_relocation, sonoma:        "b160b39ae54d99257f1b3ba136dc099b54537ada0c6d1ca1a8355de54238e1cf"
    sha256 cellar: :any_skip_relocation, ventura:       "b160b39ae54d99257f1b3ba136dc099b54537ada0c6d1ca1a8355de54238e1cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71870cae9373e9269970e4375d9a424f55f7a54f823992329ac528451f2ab6c3"
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