class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https:github.commikefarahyq"
  url "https:github.commikefarahyqarchiverefstagsv4.44.1.tar.gz"
  sha256 "e66da5ee0c081d7974bae6a59e4791ba354178ee32ea78ab1b95d4dd60b2813d"
  license "MIT"
  head "https:github.commikefarahyq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f34114d1e8dd3fabdcc08f1f21fbd4e5940e92fcfe94b2767f448f27bdcc122b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a06376d82a3b8a37315beec74c80ff9869fc9454926f062b512f06b4daedbd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "837129b4a7c4e71329cb52fcee2fb74682ac28d6282bfb9e5e9942190622b67a"
    sha256 cellar: :any_skip_relocation, sonoma:         "32153718e986010fe797558feae873f4e9bd4bc9b6a5f724994e5572ed3f13e4"
    sha256 cellar: :any_skip_relocation, ventura:        "ae24c8d84bbad1cf08f7e27841f64d6adc46abdf36eae551ecddead1bfd16769"
    sha256 cellar: :any_skip_relocation, monterey:       "f10056eb2cbd28048924aa667b5c40833712baaefe47a630274ea969f5bf1452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ab27852d8aa88a2d2ce3485b4fe1c5d2d51f5c6dc39d6540fd092dd45a9e528"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin"yq", "shell-completion")

    # Install man pages
    system ".scriptsgenerate-man-page-md.sh"
    system ".scriptsgenerate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}yq eval \".key\" -", "key: cat", 0).chomp
  end
end