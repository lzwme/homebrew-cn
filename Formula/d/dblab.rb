class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.47.4.tar.gz"
  sha256 "943301610799203c2aa329af875bd5175790aecb592637d06ec879e21f28f794"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80171fc97caa34d16687aa97cc33cf660182ef98d750b28d292aa00a3dd1d089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cb1d97fb17e960bfa97b5037ba50f9593e95d489b74617dc0b066b0f34b3d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "339501c962865e604a332d30777f66ff4c39288abe85dcd676bbdbeb9e1dcd5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba6a9740fb127db836c6abd6d96971ed8cd311aaded622eb23b98e699135a3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5ac2cf194f1200955fdc6eabd3782da8d2c94207541b3399118a38105b3df4c"
    sha256 cellar: :any,                 x86_64_linux:  "fe0fa960369f5d749f2eb2c57fdf37ce6767ee217393940e2fab51b3c6d4cda6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end