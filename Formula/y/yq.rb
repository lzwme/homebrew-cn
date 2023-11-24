class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghproxy.com/https://github.com/mikefarah/yq/archive/refs/tags/v4.40.3.tar.gz"
  sha256 "238b695d372753a32bc0b8500a7ca99f98cf98d7855c3e84d6984a2b035b6268"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd9e357dd6d9e5be6d6deb4e0493bc6ffa7f981117a8f691b127324f9f4c438"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cf1f01b4018692b8f6e1a668d539d1e6127965a7e05f83db450d078b624f701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec142692774d488e766ad48528e5ca24afa940c26195e87a6196f27d8614a80a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bae30911b94b4ea7b76888a5c7ddef972a5ce3b26cd51107053e7e5092e1997"
    sha256 cellar: :any_skip_relocation, ventura:        "97162167b5a010f1e78b10a37f5fe68b1531a24a27df1055800c85ae4710b3d0"
    sha256 cellar: :any_skip_relocation, monterey:       "f10200923b57e3847b3040a800d7b1c4055ddd508616c0b71d1e4284790a7d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb437b63a62969af08c1b23cf3ad957a646dfb87206b6e0d101403fb9fe32fcb"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin/"yq", "shell-completion")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end