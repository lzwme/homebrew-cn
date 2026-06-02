class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://ghfast.top/https://github.com/pgrok/pgrok/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "98599e07212151639e1acc5817f3d142dba6d533fbbee5c1d3f87d9588e2002d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75be3a6be051c2eff9e0de5eb1a5fc4e446996d3e926267486de7ac6fa5ec205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75be3a6be051c2eff9e0de5eb1a5fc4e446996d3e926267486de7ac6fa5ec205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75be3a6be051c2eff9e0de5eb1a5fc4e446996d3e926267486de7ac6fa5ec205"
    sha256 cellar: :any_skip_relocation, sonoma:        "6604f9c6a795e8d918dd4ea3c33ab35663030ceecac0c22d7cd7b0e3408f455d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dfd934007760baa470550c6cfb2293bc78800cebbc5dcb2d5cd2de1a7aa530d"
    sha256 cellar: :any,                 x86_64_linux:  "2ddaab02fc796b6169edb106c97b43a8532f2647364d3028b747fa6a155eff40"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./pgrok/cli"

    etc.install "pgrok.example.yml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    system bin/"pgrok", "init", "--remote-addr", "example.com:222",
                                "--forward-addr", "http://localhost:3000",
                                "--token", "brewtest"
    assert_match "brewtest", (testpath/"pgrok/pgrok.yml").read

    assert_match version.to_s, shell_output("#{bin}/pgrok --version")
  end
end