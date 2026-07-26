class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.1.2.tar.gz"
  sha256 "f64d3039f6022e8df4ddd7da3b900346ba1055a4eba4f59ec3e2e42e1ea5274d"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eea5247452bcbba08814dcd8d8c3b68b7f370c288d44da9f62428e139f9db0ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3779faac139c0a29751cf1fe88b334dfe248179719a6568d677a3977b79ea584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f8a869344b4e3b3498aede2a661b3026b224d76844cea25bcefb0eaea0093cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dedc50ab8da720b021ccd22724dee10bad187dc43126ebd33cbead816361a1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04920a7006471fcf32ef47257d91025183dae7f885c48c6e78060768537ff5f6"
    sha256 cellar: :any,                 x86_64_linux:  "a22ec839055be37005a0b1463a2042a7133bfcab60f387bca10e36ea45e14bbd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end