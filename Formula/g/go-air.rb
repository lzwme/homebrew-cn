class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://ghfast.top/https://github.com/air-verse/air/archive/refs/tags/v1.67.1.tar.gz"
  sha256 "5cefce955beb727e3025cfa10df022d592c3d447a4d55aa62d25080dc5c936f3"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03e74409d56fada8b4e312f245f019f151195d6ede528a47fe32920f94bf8b54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03e74409d56fada8b4e312f245f019f151195d6ede528a47fe32920f94bf8b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e74409d56fada8b4e312f245f019f151195d6ede528a47fe32920f94bf8b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26f6d593d5cdf190e082a4c0c479647bfe01b9d7521ced5eededa1aeb94e91d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f550df1934e1e65be9a8589dd2e767e757b02b09885d7f694d919bd5c58a3b"
    sha256 cellar: :any,                 x86_64_linux:  "afa9fd4921af9257be7dfcb73e607eb15afba034040dd552fc2a4f037c02b29a"
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