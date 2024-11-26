class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https:docs.styra.comregal"
  url "https:github.comStyraIncregalarchiverefstagsv0.29.2.tar.gz"
  sha256 "bf1367954072c565056e6e9c29c477ee18d16d3a3b06f523212597404efdc760"
  license "Apache-2.0"
  head "https:github.comStyraIncregal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a680e72469c2fb37d63092e46e02ef8fde288839d367c6677173c4ec4ac0c077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a680e72469c2fb37d63092e46e02ef8fde288839d367c6677173c4ec4ac0c077"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a680e72469c2fb37d63092e46e02ef8fde288839d367c6677173c4ec4ac0c077"
    sha256 cellar: :any_skip_relocation, sonoma:        "3062812d9e9103c84d661cf90fdd55d2c5c0782613b79c2848c1ee7aead6632f"
    sha256 cellar: :any_skip_relocation, ventura:       "3062812d9e9103c84d661cf90fdd55d2c5c0782613b79c2848c1ee7aead6632f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8e9476623d7b3585717d9fb0fe8716ffa6c1880c0f70aa875b21957d65467a"
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