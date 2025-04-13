class Dockerfmt < Formula
  desc "Dockerfile format and parser. a modern dockfmt"
  homepage "https:github.comretepsdockerfmt"
  url "https:github.comretepsdockerfmtarchiverefstagsv0.3.5.tar.gz"
  sha256 "7ea7e46a3d04618d229333ebddfc4786ce9dfe4bdf6f1c1dc82cf3deb9612b14"
  license "MIT"
  head "https:github.comretepsdockerfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817dd9b6ee04239bed351847c818e3b03ad416de6f92c382b2912946adf6dad6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "817dd9b6ee04239bed351847c818e3b03ad416de6f92c382b2912946adf6dad6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "817dd9b6ee04239bed351847c818e3b03ad416de6f92c382b2912946adf6dad6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa53942ecbce05e5cadfbe91181a9a59821e289532aa4c16fc7586ad91815e4"
    sha256 cellar: :any_skip_relocation, ventura:       "2fa53942ecbce05e5cadfbe91181a9a59821e289532aa4c16fc7586ad91815e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3eac7455c0c547cf141b7911cc85ee6a3b92b2a54bba7ab4429d72dfccf2aed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"dockerfmt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockerfmt version")

    (testpath"Dockerfile").write <<~DOCKERFILE
      FROM alpine:latest
    DOCKERFILE

    output = shell_output("#{bin}dockerfmt --check Dockerfile 2>&1", 1)
    assert_match "Dockerfile is not formatted", output
  end
end