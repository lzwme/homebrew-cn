class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://ghfast.top/https://github.com/air-verse/air/archive/refs/tags/v1.65.2.tar.gz"
  sha256 "c9a5cd7a4d4c7e07575df15892f7223a0d378e3e3d2f595486ac56dc188841ca"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f1344105d86b5f1ff5a840146880ad6e7f790f2b675974a64285a8fa42936af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1344105d86b5f1ff5a840146880ad6e7f790f2b675974a64285a8fa42936af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f1344105d86b5f1ff5a840146880ad6e7f790f2b675974a64285a8fa42936af"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcccee25ac42f472541f73b8b47760fc2bb79a03d41f9253e7a9c84533359a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b6e5bf2bd04c4a1608514d3e049853e3132a3c4a43bc97286028f14abaf34b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ab75c5d0f98ff2bc7d095830c77ac8e4ecb07ad519b524260a50f751457c2f"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = %W[
      -s -w
      -X main.BuildTimestamp=#{time.iso8601}
      -X main.airVersion=v#{version}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v 2>&1")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end