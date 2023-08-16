class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://ghproxy.com/https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "83b2b004bfdd34801ca8b55b9ccbc014545c9a51d0d8556bc23c4f8b0584b559"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9edca5c1ed47c84b704625048b5b9d7138066a45b40e5fb7152a2ab79e8b19d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9edca5c1ed47c84b704625048b5b9d7138066a45b40e5fb7152a2ab79e8b19d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9edca5c1ed47c84b704625048b5b9d7138066a45b40e5fb7152a2ab79e8b19d7"
    sha256 cellar: :any_skip_relocation, ventura:        "6d3bbfc633a381236d1c2b51051d55f17c9f1a092cf8dccbe2d9e202dbeeaf31"
    sha256 cellar: :any_skip_relocation, monterey:       "6d3bbfc633a381236d1c2b51051d55f17c9f1a092cf8dccbe2d9e202dbeeaf31"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d3bbfc633a381236d1c2b51051d55f17c9f1a092cf8dccbe2d9e202dbeeaf31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c489c52bcc2bc5cb98799d995129015c586487b8b2eee89e086591632eb25cb9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end