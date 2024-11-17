class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https:github.commikefarahyq"
  url "https:github.commikefarahyqarchiverefstagsv4.44.5.tar.gz"
  sha256 "1505367f4a6c0c4f3b91c6197ffed4112d29ef97c48d0b5e66530cfa851d3f0e"
  license "MIT"
  head "https:github.commikefarahyq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db43db890d2b7994b7d49c95db9abc850d8ece75953fd841f962348a50c9ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3db43db890d2b7994b7d49c95db9abc850d8ece75953fd841f962348a50c9ad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3db43db890d2b7994b7d49c95db9abc850d8ece75953fd841f962348a50c9ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "58160a43a7ecbd19bb8f688799c094d0405765c6967e6f7073b1d88a757c59be"
    sha256 cellar: :any_skip_relocation, ventura:       "58160a43a7ecbd19bb8f688799c094d0405765c6967e6f7073b1d88a757c59be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca42a0755e01f493d1b24419ad94f5b637d13d9fbfe256e8491c82e27c7e74c"
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