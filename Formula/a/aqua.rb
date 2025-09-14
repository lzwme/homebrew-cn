class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "bb173cca2a4ba5769ab0202f470b86af9f588bb47d40cad7deb8d290fce561cf"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a15b61a0e1d8c60a74a746a1932fb89a9da3342cff69b325c8c59c56329938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81a15b61a0e1d8c60a74a746a1932fb89a9da3342cff69b325c8c59c56329938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a15b61a0e1d8c60a74a746a1932fb89a9da3342cff69b325c8c59c56329938"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e94fbed07654a167fb6e1f1b39bc63113087e84ec16f25b5a2ce4407e57040c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9873de7b94a1c82e0e126831a4bd47f93383cf152c9e1d28747fa5a336a6c8f2"
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