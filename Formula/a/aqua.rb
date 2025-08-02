class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.8.tar.gz"
  sha256 "637df9a6431923b007c421797487f38aaa7e293feabe1f7d7f1a69d117033fc4"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd32ac3c733c430bdae6f3a29e6dfdcd3cbd3604f8aa685877b0eeadf57bda96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd32ac3c733c430bdae6f3a29e6dfdcd3cbd3604f8aa685877b0eeadf57bda96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd32ac3c733c430bdae6f3a29e6dfdcd3cbd3604f8aa685877b0eeadf57bda96"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc9c2711ae36adbafdc28cc4e4bb10c0e79368dbb0a23c4c1a91e8ee0bb862a9"
    sha256 cellar: :any_skip_relocation, ventura:       "dc9c2711ae36adbafdc28cc4e4bb10c0e79368dbb0a23c4c1a91e8ee0bb862a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c7f3154b21b3deb6e41b479354fa575c94b338d0974151256e65f32ee665d1c"
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