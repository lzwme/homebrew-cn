class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.9.tar.gz"
  sha256 "5c0f20c09e50c1cd660c6aed6fe4e6c360763fad90fee47a9f9c03a40deefb8e"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f0e5edeb1ec7a703e3704b1101e30f14fe70fecb1f18130539d9472e1835f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f0e5edeb1ec7a703e3704b1101e30f14fe70fecb1f18130539d9472e1835f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28f0e5edeb1ec7a703e3704b1101e30f14fe70fecb1f18130539d9472e1835f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "69e6611db9490f1c40488ced10404d4fc33ce9308bf69fd1cf5fd362398bc5ee"
    sha256 cellar: :any_skip_relocation, ventura:       "69e6611db9490f1c40488ced10404d4fc33ce9308bf69fd1cf5fd362398bc5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cfd549b43f1de30a2bc4ae84235b202da203470d21893437233aad0542f96f2"
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