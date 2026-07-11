class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "563206ea6c849b774bb518ea2ffe39461ad7aaa9061ce179cf44faf3df476835"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ddca798abffbd9a487938af64d483e77511fcaf61ea0f288e4a10da534acf4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "925cebacef7cd4434c23182ea88a15ae3171bffb5b387a5e1f48633e942603e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469c87914aad8cc7d2b1b9848556157c2315d5ac508f60b8c1423b54b95c6bca"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5af4518fe94568991b36cd64d24d2f34446e9b0c93d07cbab27b19e43d8dcbe"
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