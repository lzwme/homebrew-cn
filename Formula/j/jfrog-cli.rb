class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.58.1.tar.gz"
  sha256 "ff98c671cb212c957ce20fde10d7716262420dcbabbf3eb2202be4a4b5f61873"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b256bf7ecd587952d4b3eeb65f37c96a95f4812f66b7363a0de60ba70ef158fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c7b2ad6af489cad8ac42ade63ac5c58c5f16d11b535ca5385b0e5ccb75cd459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae5f839a1879cee426f108fb9831d1a738bfcbb0c8b7e7945cec4d20a9358ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c75b7916e3c6eef61d19a46536cb5978cda597a7e99d7790d6cd72cb9c08b1c"
    sha256 cellar: :any_skip_relocation, ventura:        "2f6c8060955889063adaa1ef49705f3c27ebe89ad3922067d7704363ac4e16f4"
    sha256 cellar: :any_skip_relocation, monterey:       "99b5f911cd90b81f935ac9b47ab89ea3a014500a5878f6b45ce42c40ed3915c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ab5e4b5ab75cdaab5557b325cba46027b09595413c56ba83f25086a110b4326"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jf -v")
    assert_match version.to_s, shell_output("#{bin}jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}jf rt bp --dry-run --url=http:127.0.0.1 2>&1", 1)
    end
  end
end