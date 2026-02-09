class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "0516890e068d9b5be37d2551290e3bb98d477404a548e2cad33436614651098b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "423f4f245c4d9832f3b52d2efbff0a3340c2046c49d1e9f37e349ee96cc5a3fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a2dc82f781ad79d114f28d566d4a442280616f527c799eede1e5187fe711379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a17dece3e2824792d8dbd4d4cb871c5c6d55f0ad36e3b08a25d20fd3792aefcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "622262d08ef1a036373cdc9d324f93781ff152a2e0a06c5a979fe7db52a581d8"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end