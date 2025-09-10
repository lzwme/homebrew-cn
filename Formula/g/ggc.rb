class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "53b29d6cdde30aeca19730fdc92fd6b6f2cc1548079e7129d8ed9bab11f36905"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af045bb26f4be9490bf2c6e8cc5bede98dde4c1e61a8d84529e0260dedb00206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af045bb26f4be9490bf2c6e8cc5bede98dde4c1e61a8d84529e0260dedb00206"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af045bb26f4be9490bf2c6e8cc5bede98dde4c1e61a8d84529e0260dedb00206"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea5ef0c85a55043ab456480d02af5dc9757dc781ea9abd50da46b67e1c9227f8"
    sha256 cellar: :any_skip_relocation, ventura:       "ea5ef0c85a55043ab456480d02af5dc9757dc781ea9abd50da46b67e1c9227f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4afb46f748ac94bf72f1a859d8d4f7453f754f5920ab8a7c053b3192615b5d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4657b589422d0acedeaf9247339831e8b1726151e74b9cb09a29611829e88717"
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