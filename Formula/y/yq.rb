class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https:github.commikefarahyq"
  url "https:github.commikefarahyqarchiverefstagsv4.44.6.tar.gz"
  sha256 "c0acef928168e5fdb26cd7e8320eddde822f30cf1942817f3f6b854dd721653f"
  license "MIT"
  head "https:github.commikefarahyq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "895efd8c8aa9ec322d9cd45849e68dcfe6888a75968f50ae6e045bad830a65f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "895efd8c8aa9ec322d9cd45849e68dcfe6888a75968f50ae6e045bad830a65f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "895efd8c8aa9ec322d9cd45849e68dcfe6888a75968f50ae6e045bad830a65f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb82f632ebd0305b79d05f7c24ef6658ceb7b6eaa746f2625a1e9a2a4c76b453"
    sha256 cellar: :any_skip_relocation, ventura:       "bb82f632ebd0305b79d05f7c24ef6658ceb7b6eaa746f2625a1e9a2a4c76b453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cdfc29fd95e76f9b292575b41d1eebc981ec81644c071f771a7ab56b1b97790"
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