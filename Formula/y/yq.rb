class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://ghfast.top/https://github.com/mikefarah/yq/archive/refs/tags/v4.48.1.tar.gz"
  sha256 "591158368f8155421bd8821754a67b4478ee2cde205b7abfbf2d50f90769cf0e"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fa80ae6438de0ccabfbd8759a6902df0c51c42e015785e362ae3cea7af950a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa80ae6438de0ccabfbd8759a6902df0c51c42e015785e362ae3cea7af950a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fa80ae6438de0ccabfbd8759a6902df0c51c42e015785e362ae3cea7af950a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a583726ae07c0fa05b53d5377630538bdf0c98fb5e3abdd36f5ec5417b05ab27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d6a77108dd8ee100c2176f2b49938140c05842400b9c90f41407342ffdfd92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1bf167eb9c36e2652c95b48ffb6f44ea8be0c8bcec9e93c2fbc59f64e87d40c"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
    assert_equal "cat", pipe_output("#{bin}/yq eval .key -", "key: cat", 0).chomp
  end
end