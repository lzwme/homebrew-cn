class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "8602c62d8005c708a4e54cff6da2f21fe31753d2fd24b588bba7d67993441bda"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead0b9f777f5bd453683cbc0297817122aeba403789a1fc8334628f258bafe4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ead0b9f777f5bd453683cbc0297817122aeba403789a1fc8334628f258bafe4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ead0b9f777f5bd453683cbc0297817122aeba403789a1fc8334628f258bafe4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f5c57ae4c51bb083041e973e2b049dc9b870031b36a741477ea9b3aa5ce57fd"
    sha256 cellar: :any_skip_relocation, ventura:       "8f5c57ae4c51bb083041e973e2b049dc9b870031b36a741477ea9b3aa5ce57fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2e30b1ef07223aab8da081e193bddff7db896319698f99dce3a7a3125066506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2f7116cc8117fb71e85cbefd719af5024510ca3ee5e40682126394c6a2b3f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end