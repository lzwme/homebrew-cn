class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.49.4.tar.gz"
  sha256 "b70fd4a5f697c6d3864ff163f00a45a4843b8ffbb90a6af512d277d35bc2fefe"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89fe74d88784fb816f79d090e21082f16c2113febc7980a56f6248e549df32fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce818939210a872eee630c3186c382c27aac7944bf87e83768934cba4defecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c63a53020c4c2a35043d29972d75d7707dfad807caed660d4b381d181398abf2"
    sha256 cellar: :any,                 arm64_linux:   "9e00e955b51c54cff825b875a38bbc7825658054bfa55df63ff118b668ed801c"
    sha256 cellar: :any,                 x86_64_linux:  "8283d9b8358e0932db88f8865b864e1ecb66c1ecc88d4cb9207a753bd6c7f5a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end