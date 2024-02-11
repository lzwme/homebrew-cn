class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https:github.commikefarahyq"
  url "https:github.commikefarahyqarchiverefstagsv4.40.7.tar.gz"
  sha256 "c38024d40ee37d26caba1824965d9ea1d65468f48b2bacd45647ff4f547fa59f"
  license "MIT"
  head "https:github.commikefarahyq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae120bb652a1899b07742773b3f29d092252466e758e11b9936b8adb758ac098"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "420e9b4f7662ed6ffcbc01102030f30abd3b11aac811c61a285a74cb8b5b6f7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14882d182eefc14dc8b5697c24ea3e09df40c8ca45fb70536a17601f68ab0def"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b6c8d4678f9807cade82cddbb54365b3f79ffc6ff5d3ce995ebb6684a66d104"
    sha256 cellar: :any_skip_relocation, ventura:        "43812cc640af7a5b695a34a1ccea048e40212864d054cd2177cdd2afbcfe502c"
    sha256 cellar: :any_skip_relocation, monterey:       "eef56bff54c49fce95472e0ad7ff3343c9b591d50c56bb2a3c5dfa929c10112e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ad8aad7eaf0269ce1bca1996c958e3d96465748a34b86bd5993fed07b306003"
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