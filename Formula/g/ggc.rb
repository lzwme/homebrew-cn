class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.6.5.tar.gz"
  sha256 "6dc136e8abb48758d3f64917a18c85025ce1362f315efd1b7dcfd99a2f3589f3"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f98e138e036dbb223000ddd775dc93609884b4634f20f3e0715f20dc384a69e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f98e138e036dbb223000ddd775dc93609884b4634f20f3e0715f20dc384a69e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f98e138e036dbb223000ddd775dc93609884b4634f20f3e0715f20dc384a69e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa2dd376da7eea5d629ee00497c14f052eadef20f7c399baaddd797e4de7fd88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "016762a67cdb85ad76a3f21a5f5d1e62e56927873835f9e5522fb228f0b4dedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e395a84a62ec9fff3b6a14381ea2484fe74788e8140cb709938bb81dc4bda3f1"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end