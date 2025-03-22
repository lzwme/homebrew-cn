class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https:github.comwagoodmandive"
  url "https:github.comwagoodmandivearchiverefstagsv0.13.0.tar.gz"
  sha256 "91449d9777c3b52ddfd9cf922b8bb980cd9270eaf056ea70b319a8779f7e2c2b"
  license "MIT"
  head "https:github.comwagoodmandive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a2438765e47aded7dfd78aacc90e975910ee5031301e86f8c432b61d497595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a2438765e47aded7dfd78aacc90e975910ee5031301e86f8c432b61d497595"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79a2438765e47aded7dfd78aacc90e975910ee5031301e86f8c432b61d497595"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c1f5f308785a0e356662f9679f18f78a41c9c343f7055bb9657b784db70b99"
    sha256 cellar: :any_skip_relocation, ventura:       "e9c1f5f308785a0e356662f9679f18f78a41c9c343f7055bb9657b784db70b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d2c4e660a335804b98e10d62cb1c3051856a15aa201d031415b95ccb6e3fc31"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath"Dockerfile").write <<~DOCKERFILE
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    DOCKERFILE

    assert_match "dive #{version}", shell_output("#{bin}dive version")
    assert_match "Building image", shell_output("CI=true #{bin}dive build .", 1)
  end
end