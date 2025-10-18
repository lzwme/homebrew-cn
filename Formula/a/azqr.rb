class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.11.0",
      revision: "2e3bd6ccbfad2af7952f308a982631e510227b41"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aa6d7d1f25c18d322e74a2a07fb14f0cba46afea08f983b60a93c0cede601ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aa6d7d1f25c18d322e74a2a07fb14f0cba46afea08f983b60a93c0cede601ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa6d7d1f25c18d322e74a2a07fb14f0cba46afea08f983b60a93c0cede601ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "af3cd72453321a52fde32f32049c6986fdc2699772d3559981713eae2bbfeffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95a2921f706bc92265a6f4ceb4dcc29bef083f569fd9d2f92e621b353dc810c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e87b02c0c0afc133f4b4634b658b7327d3532e46c2c9794059e94001599e502f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end