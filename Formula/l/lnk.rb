class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://ghfast.top/https://github.com/yarlson/lnk/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "089b210a5be46d3741ecb6575aeca3c28e2a59c4851dd76a9e4ed30575ba09b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bab1383a305d71b530fbb4556be4b3ef14438bbe6e84a830c49e161c32a83e21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bab1383a305d71b530fbb4556be4b3ef14438bbe6e84a830c49e161c32a83e21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bab1383a305d71b530fbb4556be4b3ef14438bbe6e84a830c49e161c32a83e21"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdbd7226b2d1939dee18b80b4866ae0415d96484454930e7948fd02f0a95f75b"
    sha256 cellar: :any_skip_relocation, ventura:       "cdbd7226b2d1939dee18b80b4866ae0415d96484454930e7948fd02f0a95f75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b17918b6ecd8e0a50e1da0f996ad2cdef67f5f33c85caeff4f996243107542"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end