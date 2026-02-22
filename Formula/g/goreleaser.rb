class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.14.0",
      revision: "ef778d3a7fd3cc76ffe0820a795c34e1fb5717cc"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcfabbff76be58df47dd60f0821d80dcc213f7027cb9c51cff8bb149d2eda3a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "708c19154760c2b08b45a752c6c2fffa4c89e27cdcffcfbf40bcf98db7fd12b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24a392ee92739ce990c1ec92a7112a474ddf4b372a41b5ddd288773a997537f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d2eb2cb7379cadfdd1c2481566e064db0925c407a08ae8960c859867f0a3053"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba3e600560baab7911bf9da94bc323f67a00781b9312ff87814e0aa5481dd68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ef21308005dcccdc62ee3830e8dd1648ec2a53e0c0676bf228b53c0a76cdfb"
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