class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "39aeee0d7727f607b7c8a0a341bbbdb126419544825d09da7b72a92f71b10457"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99b7a4a26e1562c578089b2567ae7247d67aabfc94be5288870fedab602d9f46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03588a081f001338cb44fd4e16a18abfdbc3214f9c0b563c12fa7dd42073fea9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfbcbb1a1fe6d94d97ac4fbef6a77571182cbed7499fe18d73e2c3f29f77906a"
    sha256 cellar: :any_skip_relocation, sonoma:        "640137c2bb446c1e7a7379cd927823f92d9ec8e6e396602e78255a289b65e405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad50d6052767ba5a6b9577c94453edb2c8c2d9ceac706bc83ce0954db466cf6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69830a1e1a8b31b33c75ccb5d466f1e51a13e7ef6d70adc98b367e8173f92044"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end