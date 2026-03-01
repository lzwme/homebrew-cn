class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://ghfast.top/https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.20.tar.gz"
  sha256 "8bdff9b14eb5a767eed77c72abaf75cca4a47044a6bde4ce5ca0df33140ffc1e"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c289cd683ed7e8abf44e592cd9f188333bf2eb651e06994f4695beb63e864507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c289cd683ed7e8abf44e592cd9f188333bf2eb651e06994f4695beb63e864507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c289cd683ed7e8abf44e592cd9f188333bf2eb651e06994f4695beb63e864507"
    sha256 cellar: :any_skip_relocation, sonoma:        "d447e1797fc7d9ab25d0bb30a387b738eef935b943880b6160794d9d8a17d777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d63b24241a2141768a2feefe9df469e09cae35ef5d06fe4560af81ddbee88c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21004fd3e8953d0d5aee613c4d028ea4bb03a9fc88e21293786873c1150ab606"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end