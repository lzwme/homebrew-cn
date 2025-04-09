class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.38.0.tar.gz"
  sha256 "cd97c64ff32c179e4ad249adad9748436c63beee79b7397798573871ca3be676"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed7def5c63da72dbea241c3b6c4e468865d2d17bc523d07b031399aaa508ceea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed7def5c63da72dbea241c3b6c4e468865d2d17bc523d07b031399aaa508ceea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed7def5c63da72dbea241c3b6c4e468865d2d17bc523d07b031399aaa508ceea"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb0670ba4978a010e01d30cb3414d027c59c84f3ec9b94d6ee67ab52990a65d"
    sha256 cellar: :any_skip_relocation, ventura:       "ebb0670ba4978a010e01d30cb3414d027c59c84f3ec9b94d6ee67ab52990a65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df493ca4991af5ca14789a01f8c4e59306cbbfa126695b6fae856ba58cf8de07"
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

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end