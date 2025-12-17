class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.55.tar.gz"
  sha256 "85f965d01357e4892e82caa5bf692f82818a8dff63c564e381029f7b9c3f09b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b68d177c7b84565930efe938ad3a1dfbe6532770c7a31ee3c6737b7a6acf106b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b68d177c7b84565930efe938ad3a1dfbe6532770c7a31ee3c6737b7a6acf106b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b68d177c7b84565930efe938ad3a1dfbe6532770c7a31ee3c6737b7a6acf106b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7ff45953a6db1398a7aa7356bdd3a4d8854c0382dc073b4288040b3d6bf7d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35e69d027e3fd56f70e644d39f3d481ed02484ae6fe72e49eb179b4e9e2b5891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55cfad588e0a188eb8b39179f94f198572ca76b012a1b552548b56747ab013c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end