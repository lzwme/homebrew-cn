class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://ghfast.top/https://github.com/air-verse/air/archive/refs/tags/v1.67.3.tar.gz"
  sha256 "6353dea0cdef36eb5467e12ba7967ad3da94b68132a6a50a429d0dfb60b3a9b2"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "403aeb44fa144945e8b8a5a1286620519df0c40c430e82eccfd0816ea360ce10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "403aeb44fa144945e8b8a5a1286620519df0c40c430e82eccfd0816ea360ce10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "403aeb44fa144945e8b8a5a1286620519df0c40c430e82eccfd0816ea360ce10"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e68fbdaa1bf86e1537c35181729608f9bebfd55cd8e3307db80cdb4b81bb293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70684d518c2aaa1d557fa83acc9efc4a430ec5f01717c43db0afcda31c2ae157"
    sha256 cellar: :any,                 x86_64_linux:  "3c669d71ad499b146aa0c324ac86f1caef2c7adecf22fe5e69832459b44d6eac"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = %W[
      -X main.BuildTimestamp=#{time.iso8601}
      -X main.airVersion=v#{version}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"air")
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