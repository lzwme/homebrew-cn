class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.84.tar.gz"
  sha256 "eede5ce0b2834b5c3511232ce0014156d5604c4f2fdd3a298534aead3835926c"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abf941d3622c451e5dbc46fd60212cfc717b2f370bc52efe229d24000fbb32b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf941d3622c451e5dbc46fd60212cfc717b2f370bc52efe229d24000fbb32b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abf941d3622c451e5dbc46fd60212cfc717b2f370bc52efe229d24000fbb32b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ebda56d0ea6c5e4d54de4bccad2394cea01f9ac06ad9cd47d6ad56494ef1f0b"
    sha256 cellar: :any_skip_relocation, ventura:       "9ebda56d0ea6c5e4d54de4bccad2394cea01f9ac06ad9cd47d6ad56494ef1f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a16c35c9a9fe9e38bcda25b7329b70ac34b91e0b91b261700a2dbea4b475038"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end