class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.56.1.tar.gz"
  sha256 "37f2a38a9493ed028e80240c2a2ecb4558ef02c34e1cba75143c7ccbdc34ff20"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3393b6f3a59d1c62f07313e09194486de062367ce68409782f57e3bd9a3d2c53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3393b6f3a59d1c62f07313e09194486de062367ce68409782f57e3bd9a3d2c53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3393b6f3a59d1c62f07313e09194486de062367ce68409782f57e3bd9a3d2c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5b5fe91ee51422d423fd7e124c41c5ef01304801be7fd394c3cfdd8bfbeb648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7969e04554ec1781f3dffc6b4c4d69bd9aadddb5b72d1e43ff843dd4c46f5c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a00133185c4d7f262e95094dc1ca6dede649067ad503eb9f21b8c8e62dc0942"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end