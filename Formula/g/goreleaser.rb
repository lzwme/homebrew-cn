class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.14.2",
      revision: "206ffbf90b855fc86c1c687ff3ae5bb1da1e94d1"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3958ade16e3e08356b2ac84b78b168000aa89cab3e4e11a6f395d02decfc149b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0bc23a7b6da9cd54c9570a2571d9a39bdba62d049387bfa70846ec126000bed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3274e1525fcc7e3d2ae782ec934f4cca6956e1a94ae1573f77f25200cd61245c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e91ba172adc15bfd39b7507ac06d24ac55c7ec9288e37d1859ff960aebf9fd46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "123a117e9170fb9161559c39fe54a936951e618869938ae365174ecb503eaac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc81cd9478fb53f498d6ff7d87f354bbecd8b09e170792d0dfd8b98cdb97e4f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end