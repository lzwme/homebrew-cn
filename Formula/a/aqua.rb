class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.56.2.tar.gz"
  sha256 "744e6ed48680f73901f92d7d7cc25f4c0b4a3e7332056cc8c9c06b0e7d757c2c"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcd618ca040d6b2889870a91354a9f09a962f0ec7c0471be80bbff5e4e117faa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcd618ca040d6b2889870a91354a9f09a962f0ec7c0471be80bbff5e4e117faa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd618ca040d6b2889870a91354a9f09a962f0ec7c0471be80bbff5e4e117faa"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e5f4685ed891ece194434a9fe65dff2575c61eda74ad7a71b372dcdbfe686d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd1b3824b3a0161f8702f6e8cadc05bde6acc6d9a930bc36d705ea9e8487662e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c8c52002b6e25c4dde8f9610899d8bab4f9335fff2ff7d536dd961aa30bd4f3"
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