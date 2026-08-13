class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.1.0.tar.gz"
  sha256 "8266b363a127464259afd9b8a1aa47d579f4ed1af66b534ec8854b58c9e064b2"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11dd76b078472e1d752bf5e14886c331f16b076dfaa7a06c1fba4986afc4db4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36032d09adcb59661157188b841cae6de96ce3953e50780dccee5cf4e26610fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c202c305e977b6203c86c5191f31ec40c2a5b1df8c14b7e7b4447e6792b40f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3da0de6c9d07a37be15cf70def925cf19bc4827558f8bb85482fe7d14305775e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2c16e468d4da5bb4ebd20861e392709d987c760f5fd042de4dd58bcb38913b"
    sha256 cellar: :any,                 x86_64_linux:  "fe5974ef6960c0f805415146b212d14f13f92c6758db30fef9184cdce4903bd8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end