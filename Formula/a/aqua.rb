class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.6.tar.gz"
  sha256 "996dfb588d60034be2b180cf1b4964e9d8cc7a2d7728b24b509d841945740006"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "787b87e3e270da2680bc7e9af4a02703a6938c8a3257a81757b3ec86d08ac8bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "787b87e3e270da2680bc7e9af4a02703a6938c8a3257a81757b3ec86d08ac8bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "787b87e3e270da2680bc7e9af4a02703a6938c8a3257a81757b3ec86d08ac8bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d8f883bade459b19ffc065eec5d7c5532ee30ae947e4c14a1204b44db6a2404"
    sha256 cellar: :any_skip_relocation, ventura:       "3d8f883bade459b19ffc065eec5d7c5532ee30ae947e4c14a1204b44db6a2404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb72aa7fad7224a7f7d3b993da78b6b42191ccf7bd333425d5c23a474bbeb51"
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