class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.32.0.tar.gz"
  sha256 "0717ae4444d3e4b978da5669b2fef4ef86355568caf2eaf7d5b01fe49fecd036"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2438036b54a5b6d012778d1570351b3768b974275567432e28aa9edd0d42b8b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d6597d6226552bc8151cae57095319f510d0d6285e98608014f2386dcadf24a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f46d9d97a092ef0d5773dd3c3b046ab02b8a4c028feb929f64ab8876d917974"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde0612f70e6e9d4ae266cf7e57ca5e08a434cdfd5c455bbbe621af792d911f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "778d8d3afe5af865700ab80f12456fd222113dc62656f3cc6200dbbf8fc0835a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4727614c67be11d0a73e23906e4ec8dccccbf398b8b82e5f3ec1dd14f41b8b5"
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