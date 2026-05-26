class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.5.2.tar.gz"
  sha256 "3e60e5880d86877e473731273f0945506a50721e071650d68cafc33ec70da1be"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb1c70569522e7388b43548b9f815384d5080f48af939c0997a3e2a58147eb55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6877e856acfa03afd3c5f737a93cf61d7759b5025c2bae804a9fd4e0ead282c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa1c7d58838b3494313bf24fd0b8181cdc15d5bd3880734ae57b0feeff12c65e"
    sha256 cellar: :any_skip_relocation, sonoma:        "540dcb841e775b4ae2c200a795658047f99c6a7b8b48a30e790e2bbb4b2891e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c831b5b0cb13189123d5015c94497a0a651da64ca5516eb47ec0361e05918a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28e48bf6b139dcfc5a748042b3ff3420f42dbfc37b0c9fcc0faa29d9b732799"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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