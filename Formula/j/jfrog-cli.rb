class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.52.2.tar.gz"
  sha256 "ce7f48289532ffb9bb3a091d0f69816282077d28703d4c11809c6956822b34c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d5df4ef5c8f0281820febf0a238d73b9f812c3db3853b4a69b9ac4d43978688"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dc3dff0577d2a413d85854da3b295f9b75488a665bbfdcd9afc17b8f955bdd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4d76a8ab62d51f21b778e192d01236d353da4f58a20d0f63db40cced28dabd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "71623413206a06e626aece76de29e90b99ea81ee64bd255952f48e51cf752835"
    sha256 cellar: :any_skip_relocation, ventura:        "2dbcccec4fe43ffe450f0ea2c2d3bf9be87b3be16458f16cb08b174b9aeef6a0"
    sha256 cellar: :any_skip_relocation, monterey:       "d3f528aefb289ce82ab19cfdb471a76ee36b195cc7eb2a06971a3e770cc68759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1856c98be9a218a637d8e3385612a50685044c3cfbf167f463a05119dc64a5ea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end