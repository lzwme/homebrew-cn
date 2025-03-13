class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.16.tar.gz"
  sha256 "17de6fb8b88f53d4bfe22fbbf3786f5e709c59b79c886b4259de8d98b53b8875"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9586f1fa0e20d3805660d0f40cf1acfbc9af663b4c7580f6c646c865cbe86e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9586f1fa0e20d3805660d0f40cf1acfbc9af663b4c7580f6c646c865cbe86e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9586f1fa0e20d3805660d0f40cf1acfbc9af663b4c7580f6c646c865cbe86e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3249c5ce321ecb8c4f80dffa1e44f87c1b9cdfbc51abeb777432da16084ae12"
    sha256 cellar: :any_skip_relocation, ventura:       "e3249c5ce321ecb8c4f80dffa1e44f87c1b9cdfbc51abeb777432da16084ae12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd75dd5ab67bad0c98ee2c6cd2377ec124df6545e645f8c6b5c62add4b86c3c"
  end

  depends_on "go"

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

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end