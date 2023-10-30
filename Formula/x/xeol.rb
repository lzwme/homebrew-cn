class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://ghproxy.com/https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "10ded34ec862269527ffa5a786f8ee53f8b936df0a2350dd199811272fe58b4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5eced04904c49d85135b2bf16e1faf37cfdf6f6c2e408d9139d97281584bf5ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26c1ba71916a092175a7c60b230afc5329be083a4b40051241c6e78b496e0734"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44d0ee767c6a15bf35f29e558049ac2e8f1ffe34636d9ecd7f31435b8d8f5cb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e64bb9bb344ba670e7a9fbcb2a0a79f799dfd2eb029189604731fc9a1a13ef42"
    sha256 cellar: :any_skip_relocation, ventura:        "2ebc167961f6c9525cda5a0b3dc71a4f8448f3283014b4fbe839a788734f5b24"
    sha256 cellar: :any_skip_relocation, monterey:       "dd68fa8a8ba7627e7fae7b9cdd6fcafedef12814bbd766111d9e1277a645ef16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14217e815f3bad21da6517e6a36888063a2bf1e2a53952fa5c747eb072b1c368"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end