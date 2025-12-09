class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "273dede89fa4e71e89e08110e2fa311e6113163200a729b10fa4bae7438e1734"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "865ebed0bc69e288fa2dec211e60120777a75483329e9fb37de871006078deec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "820ed683f5e886e7d0bd42d5804a91fe41f63c4aa43cc3434296848f75d0a017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f8ba1da9ac65dd93c622374d8d3b65d0b79cf0a0aca525d0fd7b55eb4ef5b0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "54b2c4bda70a783366babd179d92f44d1630b8cde24c565dd601b1d17d1e122b"
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

    generate_completions_from_executable(bin/"clippy", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end