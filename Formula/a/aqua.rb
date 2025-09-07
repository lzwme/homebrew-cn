class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.10.tar.gz"
  sha256 "9b113ed687fb5b7cf57d0dfb94eb09a4f1351ff1f95311078ebabad2e55a9350"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8be506b96a26dc8fab914f4903afaea906ef9ecccdaa19d907d50b36cf4c0f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8be506b96a26dc8fab914f4903afaea906ef9ecccdaa19d907d50b36cf4c0f35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8be506b96a26dc8fab914f4903afaea906ef9ecccdaa19d907d50b36cf4c0f35"
    sha256 cellar: :any_skip_relocation, sonoma:        "a29b96bfbfce7485fad12f0c342b23f9108f837b2d1204b6d21cd432875abf8b"
    sha256 cellar: :any_skip_relocation, ventura:       "a29b96bfbfce7485fad12f0c342b23f9108f837b2d1204b6d21cd432875abf8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecdf11423a892732d14521c54b60a9a51bf590259025339c775da403ba734245"
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